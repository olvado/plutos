import React, { createContext, useCallback, useContext, useEffect, useState } from "react";
import client from "../graphql/client";
import { gql } from "@apollo/client";

interface CurrentUser {
  id: number;
  name: string;
  email: string;
}

interface AuthContextValue {
  currentUser: CurrentUser | null;
  loading: boolean;
  login: (email: string, password: string) => Promise<void>;
  signup: (name: string, email: string, password: string, passwordConfirmation: string) => Promise<void>;
  logout: () => Promise<void>;
}

const ME_QUERY = gql`
  query Me {
    me { id name email }
  }
`;

function csrfToken(): string {
  return document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]')?.content ?? "";
}

async function deviseRequest(path: string, method: string, body?: object): Promise<Response> {
  return fetch(path, {
    method,
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "X-CSRF-Token": csrfToken(),
    },
    credentials: "same-origin",
    body: body ? JSON.stringify(body) : undefined,
  });
}

const AuthContext = createContext<AuthContextValue | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [currentUser, setCurrentUser] = useState<CurrentUser | null>(null);
  const [loading, setLoading] = useState(true);

  const fetchCurrentUser = useCallback(async () => {
    try {
      const { data } = await client.query({ query: ME_QUERY, fetchPolicy: "network-only" });
      setCurrentUser(data?.me ?? null);
    } catch {
      setCurrentUser(null);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchCurrentUser();
  }, [fetchCurrentUser]);

  const login = async (email: string, password: string) => {
    const res = await deviseRequest("/users/sign_in", "POST", { user: { email, password } });
    if (!res.ok) {
      const data = await res.json();
      throw new Error(data.error ?? "Invalid email or password");
    }
    const newToken = res.headers.get("X-CSRF-Token");
    if (newToken) {
      document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]')?.setAttribute("content", newToken);
    }
    await client.resetStore();
    await fetchCurrentUser();
  };

  const signup = async (name: string, email: string, password: string, passwordConfirmation: string) => {
    const res = await deviseRequest("/users", "POST", {
      user: { name, email, password, password_confirmation: passwordConfirmation },
    });
    const data = await res.json();
    if (!res.ok) {
      throw new Error(data.errors?.join(", ") ?? "Registration failed");
    }
  };

  const logout = async () => {
    await deviseRequest("/users/sign_out", "DELETE");
    setCurrentUser(null);
    await client.clearStore();
  };

  return (
    <AuthContext.Provider value={{ currentUser, loading, login, signup, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth(): AuthContextValue {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
}

import React from "react";
import { BrowserRouter, Navigate, Route, Routes } from "react-router-dom";
import { useAuth } from "./contexts/AuthContext";
import Layout from "./components/Layout";
import LoginPage from "./pages/LoginPage";
import SignupPage from "./pages/SignupPage";
import ForgotPasswordPage from "./pages/ForgotPasswordPage";
import DashboardPage from "./pages/DashboardPage";

function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { currentUser, loading } = useAuth();
  if (loading) return null;
  return currentUser ? <>{children}</> : <Navigate to="/login" replace />;
}

function PublicOnlyRoute({ children }: { children: React.ReactNode }) {
  const { currentUser, loading } = useAuth();
  if (loading) return null;
  return currentUser ? <Navigate to="/dashboard" replace /> : <>{children}</>;
}

export default function AppRoutes() {
  return (
    <BrowserRouter>
      <Routes>
        <Route
          path="/login"
          element={
            <PublicOnlyRoute>
              <LoginPage />
            </PublicOnlyRoute>
          }
        />
        <Route
          path="/signup"
          element={
            <PublicOnlyRoute>
              <SignupPage />
            </PublicOnlyRoute>
          }
        />
        <Route
          path="/forgot-password"
          element={
            <PublicOnlyRoute>
              <ForgotPasswordPage />
            </PublicOnlyRoute>
          }
        />

        <Route
          element={
            <ProtectedRoute>
              <Layout />
            </ProtectedRoute>
          }
        >
          <Route index element={<Navigate to="/dashboard" replace />} />
          <Route path="/dashboard" element={<DashboardPage />} />
          <Route path="/accounts/:id" element={<DashboardPage />} />
          <Route path="/visualizations" element={<DashboardPage />} />
          <Route path="/profile" element={<DashboardPage />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

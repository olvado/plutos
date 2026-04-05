import { ApolloClient, InMemoryCache, createHttpLink, from } from "@apollo/client";
import { setContext } from "@apollo/client/link/context";
import { onError } from "@apollo/client/link/error";

const httpLink = createHttpLink({ uri: "/graphql", credentials: "same-origin" });

const csrfLink = setContext((_, { headers }) => {
  const token = document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]')?.content ?? "";
  return { headers: { ...headers, "X-CSRF-Token": token } };
});

const PUBLIC_PATHS = ["/login", "/signup", "/forgot-password"];

const errorLink = onError(({ networkError }) => {
  if (
    networkError &&
    "statusCode" in networkError &&
    networkError.statusCode === 401 &&
    !PUBLIC_PATHS.some(p => window.location.pathname.startsWith(p))
  ) {
    window.location.href = "/login";
  }
});

const client = new ApolloClient({
  link: from([errorLink, csrfLink, httpLink]),
  cache: new InMemoryCache(),
});

export default client;

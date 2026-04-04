import React from "react";
import { ApolloProvider } from "@apollo/client";
import { ChakraProvider } from "@chakra-ui/react";
import { system } from "./theme";
import client from "./graphql/client";
import { AuthProvider } from "./contexts/AuthContext";
import AppRoutes from "./routes";

const App: React.FC = () => {
  return (
    <ApolloProvider client={client}>
      <ChakraProvider value={system}>
        <AuthProvider>
          <AppRoutes />
        </AuthProvider>
      </ChakraProvider>
    </ApolloProvider>
  );
};

export default App;

import React from "react";
import { ChakraProvider, Box, Heading, Text, VStack } from "@chakra-ui/react";
import { system } from "./theme";

const App: React.FC = () => {
  return (
    <ChakraProvider value={system}>
      <Box as="main" minH="100vh" display="flex" alignItems="center" justifyContent="center">
        <VStack gap={4}>
          <Heading size="2xl">Plutos</Heading>
          <Text fontSize="lg" color="fg.muted">
            Wealth tracker and visualisation tool
          </Text>
        </VStack>
      </Box>
    </ChakraProvider>
  );
};

export default App;

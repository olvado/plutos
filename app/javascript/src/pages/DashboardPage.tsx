import React from "react";
import { Heading, Text, VStack } from "@chakra-ui/react";
import { useAuth } from "../contexts/AuthContext";

export default function DashboardPage() {
  const { currentUser } = useAuth();
  return (
    <VStack align="start" gap={2}>
      <Heading size="lg">Dashboard</Heading>
      <Text color="fg.muted">
        Welcome back, {currentUser?.name}. Your accounts will appear here.
      </Text>
    </VStack>
  );
}

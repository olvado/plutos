import React from "react";
import { Box, Text } from "@chakra-ui/react";

interface ErrorAlertProps {
  error: string;
}

export default function ErrorAlert({ error }: ErrorAlertProps) {
  if (!error) return null;
  return (
    <Box bg="red.subtle" borderWidth="1px" borderColor="red.emphasized" rounded="md" px={4} py={3}>
      <Text color="red.fg" fontSize="sm">
        {error}
      </Text>
    </Box>
  );
}

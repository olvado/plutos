import React from "react";
import { Box, Button, Flex, Heading, HStack, Link, Text } from "@chakra-ui/react";
import { Link as RouterLink, useNavigate } from "react-router-dom";
import { useAuth } from "../contexts/AuthContext";
import DarkModeToggle from "./DarkModeToggle";

export default function Navbar() {
  const { currentUser, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = async () => {
    await logout();
    navigate("/login");
  };

  return (
    <Box as="nav" borderBottomWidth="1px" px={6} py={3}>
      <Flex align="center" justify="space-between">
        <HStack gap={8}>
          <Heading size="md" as={RouterLink} to="/dashboard" _hover={{ textDecoration: "none" }}>
            Plutos
          </Heading>
          <HStack gap={4} display={{ base: "none", md: "flex" }}>
            <Link as={RouterLink} to="/dashboard">Dashboard</Link>
            <Link as={RouterLink} to="/visualizations">Visualizations</Link>
          </HStack>
        </HStack>

        <HStack gap={3}>
          <DarkModeToggle />
          {currentUser && (
            <>
              <Text fontSize="sm" color="fg.muted">{currentUser.name}</Text>
              <Link as={RouterLink} to="/profile" fontSize="sm">Profile</Link>
              <Button size="sm" variant="outline" onClick={handleLogout}>Sign out</Button>
            </>
          )}
        </HStack>
      </Flex>
    </Box>
  );
}

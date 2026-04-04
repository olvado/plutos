import React from "react";
import { Box } from "@chakra-ui/react";
import { Outlet } from "react-router-dom";
import Navbar from "./Navbar";

export default function Layout() {
  return (
    <Box minH="100vh">
      <Navbar />
      <Box as="main" maxW="7xl" mx="auto" px={{ base: 4, md: 6 }} py={8}>
        <Outlet />
      </Box>
    </Box>
  );
}

import React from "react";
import { IconButton, useColorMode } from "@chakra-ui/react";

export default function DarkModeToggle() {
  const { colorMode, toggleColorMode } = useColorMode();
  return (
    <IconButton
      aria-label={colorMode === "light" ? "Switch to dark mode" : "Switch to light mode"}
      onClick={toggleColorMode}
      variant="ghost"
      size="sm"
    >
      {colorMode === "light" ? "🌙" : "☀️"}
    </IconButton>
  );
}

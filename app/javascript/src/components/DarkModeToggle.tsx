import React, { useEffect, useState } from "react";
import { IconButton } from "@chakra-ui/react";

const STORAGE_KEY = "chakra-color-mode";

function getStoredColorMode(): "light" | "dark" {
  return (localStorage.getItem(STORAGE_KEY) as "light" | "dark") ?? "light";
}

export default function DarkModeToggle() {
  const [colorMode, setColorMode] = useState<"light" | "dark">(getStoredColorMode);

  useEffect(() => {
    document.documentElement.dataset.theme = colorMode;
    localStorage.setItem(STORAGE_KEY, colorMode);
  }, [colorMode]);

  const toggleColorMode = () =>
    setColorMode(prev => (prev === "light" ? "dark" : "light"));

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

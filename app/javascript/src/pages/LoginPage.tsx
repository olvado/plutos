import React, { useState } from "react";
import { Box, Button, Field, Heading, Input, Link, Stack, Text } from "@chakra-ui/react";
import { Link as RouterLink, useNavigate } from "react-router-dom";
import { useAuth } from "../contexts/AuthContext";

export default function LoginPage() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setLoading(true);
    try {
      await login(email, password);
      navigate("/dashboard");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Sign in failed");
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box minH="100vh" display="flex" alignItems="center" justifyContent="center" px={4}>
      <Box w="full" maxW="md">
        <Heading size="xl" mb={2} textAlign="center">
          Sign in to Plutos
        </Heading>
        <Text color="fg.muted" textAlign="center" mb={8}>
          Track your savings and ISA performance
        </Text>

        <Box as="form" onSubmit={handleSubmit}>
          <Stack gap={5}>
            {error && (
              <Box
                bg="red.subtle"
                borderWidth="1px"
                borderColor="red.emphasized"
                rounded="md"
                px={4}
                py={3}
              >
                <Text color="red.fg" fontSize="sm">
                  {error}
                </Text>
              </Box>
            )}

            <Field.Root required>
              <Field.Label>Email</Field.Label>
              <Input
                type="email"
                value={email}
                onChange={e => setEmail(e.target.value)}
                autoComplete="email"
                placeholder="you@example.com"
              />
            </Field.Root>

            <Field.Root required>
              <Field.Label>Password</Field.Label>
              <Input
                type="password"
                value={password}
                onChange={e => setPassword(e.target.value)}
                autoComplete="current-password"
              />
              <Field.HelperText>
                <Link as={RouterLink} to="/forgot-password" fontSize="sm">
                  Forgot password?
                </Link>
              </Field.HelperText>
            </Field.Root>

            <Button type="submit" colorPalette="brand" loading={loading} w="full">
              Sign in
            </Button>

            <Text textAlign="center" fontSize="sm" color="fg.muted">
              Don't have an account?{" "}
              <Link as={RouterLink} to="/signup">
                Create one
              </Link>
            </Text>
          </Stack>
        </Box>
      </Box>
    </Box>
  );
}

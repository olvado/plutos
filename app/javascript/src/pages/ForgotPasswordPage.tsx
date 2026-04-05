import React, { useState } from "react";
import { Box, Button, Field, Heading, Input, Link, Stack, Text } from "@chakra-ui/react";
import { Link as RouterLink } from "react-router-dom";
import { useAuth } from "../contexts/AuthContext";
import ErrorAlert from "../components/ErrorAlert";

export default function ForgotPasswordPage() {
  const { forgotPassword } = useAuth();
  const [email, setEmail] = useState("");
  const [submitted, setSubmitted] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setLoading(true);
    try {
      await forgotPassword(email);
      setSubmitted(true);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Something went wrong");
    } finally {
      setLoading(false);
    }
  };

  if (submitted) {
    return (
      <Box minH="100vh" display="flex" alignItems="center" justifyContent="center" px={4}>
        <Box w="full" maxW="md" textAlign="center">
          <Heading size="xl" mb={4}>
            Check your email
          </Heading>
          <Text color="fg.muted" mb={6}>
            If an account exists for <strong>{email}</strong>, you'll receive password reset
            instructions shortly.
          </Text>
          <Link as={RouterLink} to="/login">
            Back to sign in
          </Link>
        </Box>
      </Box>
    );
  }

  return (
    <Box minH="100vh" display="flex" alignItems="center" justifyContent="center" px={4}>
      <Box w="full" maxW="md">
        <Heading size="xl" mb={2} textAlign="center">
          Reset your password
        </Heading>
        <Text color="fg.muted" textAlign="center" mb={8}>
          Enter your email and we'll send you a reset link.
        </Text>

        <Box as="form" onSubmit={handleSubmit}>
          <Stack gap={5}>
            <ErrorAlert error={error} />

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

            <Button type="submit" colorPalette="brand" loading={loading} w="full">
              Send reset link
            </Button>

            <Text textAlign="center" fontSize="sm" color="fg.muted">
              <Link as={RouterLink} to="/login">
                Back to sign in
              </Link>
            </Text>
          </Stack>
        </Box>
      </Box>
    </Box>
  );
}

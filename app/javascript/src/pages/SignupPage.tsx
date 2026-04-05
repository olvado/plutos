import { useState } from "react";
import { Box, Button, Field, Heading, Input, Link, Stack, Text } from "@chakra-ui/react";
import { Link as RouterLink } from "react-router-dom";
import { useAuth } from "../contexts/AuthContext";

export default function SignupPage() {
  const { signup } = useAuth();
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [passwordConfirmation, setPasswordConfirmation] = useState("");
  const [error, setError] = useState("");
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setLoading(true);
    try {
      await signup(name, email, password, passwordConfirmation);
      setSuccess(true);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Registration failed");
    } finally {
      setLoading(false);
    }
  };

  if (success) {
    return (
      <Box minH="100vh" display="flex" alignItems="center" justifyContent="center" px={4}>
        <Box w="full" maxW="md" textAlign="center">
          <Heading size="xl" mb={4}>
            Check your email
          </Heading>
          <Text color="fg.muted" mb={6}>
            We've sent a confirmation link to <strong>{email}</strong>. Please confirm your email
            address before signing in.
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
          Create your account
        </Heading>
        <Text color="fg.muted" textAlign="center" mb={8}>
          Start tracking your wealth today
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
              <Field.Label>Full name</Field.Label>
              <Input
                value={name}
                onChange={e => setName(e.target.value)}
                autoComplete="name"
                placeholder="Your name"
              />
            </Field.Root>

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
                autoComplete="new-password"
                placeholder="At least 8 characters"
              />
            </Field.Root>

            <Field.Root required>
              <Field.Label>Confirm password</Field.Label>
              <Input
                type="password"
                value={passwordConfirmation}
                onChange={e => setPasswordConfirmation(e.target.value)}
                autoComplete="new-password"
              />
            </Field.Root>

            <Button type="submit" colorPalette="brand" loading={loading} w="full">
              Create account
            </Button>

            <Text textAlign="center" fontSize="sm" color="fg.muted">
              Already have an account?{" "}
              <Link as={RouterLink} to="/login">
                Sign in
              </Link>
            </Text>
          </Stack>
        </Box>
      </Box>
    </Box>
  );
}

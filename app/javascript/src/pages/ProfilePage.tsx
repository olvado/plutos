import React, { useState } from "react";
import { Box, Button, Field, Heading, Input, Stack, Text } from "@chakra-ui/react";
import { useAuth } from "../contexts/AuthContext";
import { useUpdateProfileMutation } from "../../graphql/generated";
import ErrorAlert from "../components/ErrorAlert";

function ProfileSection({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <Box borderWidth="1px" rounded="lg" p={6}>
      <Heading size="md" mb={4}>
        {title}
      </Heading>
      {children}
    </Box>
  );
}

export default function ProfilePage() {
  const { currentUser } = useAuth();

  const [name, setName] = useState(currentUser?.name ?? "");
  const [email, setEmail] = useState(currentUser?.email ?? "");
  const [profileError, setProfileError] = useState("");
  const [profileSuccess, setProfileSuccess] = useState("");

  const [currentPassword, setCurrentPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [passwordError, setPasswordError] = useState("");
  const [passwordSuccess, setPasswordSuccess] = useState("");

  const [updateProfile, { loading }] = useUpdateProfileMutation();

  async function handleProfileSubmit(e: React.FormEvent) {
    e.preventDefault();
    setProfileError("");
    setProfileSuccess("");
    try {
      const result = await updateProfile({ variables: { input: { name, email } } });
      const errors = result.data?.updateProfile?.errors ?? [];
      if (errors.length > 0) {
        setProfileError(errors.join(", "));
      } else {
        setProfileSuccess("Profile updated.");
      }
    } catch {
      setProfileError("Something went wrong. Please try again.");
    }
  }

  async function handlePasswordSubmit(e: React.FormEvent) {
    e.preventDefault();
    setPasswordError("");
    setPasswordSuccess("");
    if (newPassword !== confirmPassword) {
      setPasswordError("New passwords do not match.");
      return;
    }
    try {
      const result = await updateProfile({
        variables: {
          input: {
            currentPassword,
            password: newPassword,
            passwordConfirmation: confirmPassword,
          },
        },
      });
      const errors = result.data?.updateProfile?.errors ?? [];
      if (errors.length > 0) {
        setPasswordError(errors.join(", "));
      } else {
        setPasswordSuccess("Password updated.");
        setCurrentPassword("");
        setNewPassword("");
        setConfirmPassword("");
      }
    } catch {
      setPasswordError("Something went wrong. Please try again.");
    }
  }

  return (
    <Stack gap={6} maxW="lg">
      <Heading size="lg">Profile</Heading>

      <ProfileSection title="Personal details">
        <Box as="form" onSubmit={handleProfileSubmit}>
          <Stack gap={4}>
            <ErrorAlert error={profileError} />
            {profileSuccess && (
              <Text fontSize="sm" color="green.fg">
                {profileSuccess}
              </Text>
            )}

            <Field.Root required>
              <Field.Label>Name</Field.Label>
              <Input value={name} onChange={e => setName(e.target.value)} autoComplete="name" />
            </Field.Root>

            <Field.Root required>
              <Field.Label>Email</Field.Label>
              <Input
                type="email"
                value={email}
                onChange={e => setEmail(e.target.value)}
                autoComplete="email"
              />
            </Field.Root>

            <Button type="submit" colorPalette="brand" loading={loading} alignSelf="flex-start">
              Save changes
            </Button>
          </Stack>
        </Box>
      </ProfileSection>

      <ProfileSection title="Change password">
        <Box as="form" onSubmit={handlePasswordSubmit}>
          <Stack gap={4}>
            <ErrorAlert error={passwordError} />
            {passwordSuccess && (
              <Text fontSize="sm" color="green.fg">
                {passwordSuccess}
              </Text>
            )}

            <Field.Root required>
              <Field.Label>Current password</Field.Label>
              <Input
                type="password"
                value={currentPassword}
                onChange={e => setCurrentPassword(e.target.value)}
                autoComplete="current-password"
              />
            </Field.Root>

            <Field.Root required>
              <Field.Label>New password</Field.Label>
              <Input
                type="password"
                value={newPassword}
                onChange={e => setNewPassword(e.target.value)}
                autoComplete="new-password"
              />
            </Field.Root>

            <Field.Root required>
              <Field.Label>Confirm new password</Field.Label>
              <Input
                type="password"
                value={confirmPassword}
                onChange={e => setConfirmPassword(e.target.value)}
                autoComplete="new-password"
              />
            </Field.Root>

            <Button type="submit" colorPalette="brand" loading={loading} alignSelf="flex-start">
              Update password
            </Button>
          </Stack>
        </Box>
      </ProfileSection>
    </Stack>
  );
}

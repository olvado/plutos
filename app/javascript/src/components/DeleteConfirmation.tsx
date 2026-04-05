import React from "react";
import { Button, Dialog, Text } from "@chakra-ui/react";

interface DeleteConfirmationProps {
  open: boolean;
  title: string;
  description: string;
  loading?: boolean;
  onCancel: () => void;
  onConfirm: () => void;
}

export default function DeleteConfirmation({
  open,
  title,
  description,
  loading,
  onCancel,
  onConfirm,
}: DeleteConfirmationProps) {
  return (
    <Dialog.Root open={open} onOpenChange={({ open: o }) => !o && onCancel()} role="alertdialog">
      <Dialog.Backdrop />
      <Dialog.Positioner>
        <Dialog.Content maxW="sm">
          <Dialog.Header>
            <Dialog.Title>{title}</Dialog.Title>
          </Dialog.Header>
          <Dialog.Body>
            <Text>{description}</Text>
          </Dialog.Body>
          <Dialog.Footer gap={2}>
            <Button variant="outline" onClick={onCancel} disabled={loading}>
              Cancel
            </Button>
            <Button colorPalette="red" onClick={onConfirm} loading={loading}>
              Delete
            </Button>
          </Dialog.Footer>
        </Dialog.Content>
      </Dialog.Positioner>
    </Dialog.Root>
  );
}

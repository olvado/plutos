import tsEslint from "typescript-eslint";
import reactPlugin from "eslint-plugin-react";
import reactHooksPlugin from "eslint-plugin-react-hooks";
import prettierConfig from "eslint-config-prettier";

export default tsEslint.config(
  { ignores: ["node_modules/**", "app/javascript/src/graphql/generated/**"] },
  ...tsEslint.configs.recommended,
  reactPlugin.configs.flat["jsx-runtime"],
  reactHooksPlugin.configs.flat["recommended-latest"],
  {
    rules: {
      // React is not needed in scope with the automatic JSX runtime, but existing
      // files import it as a convention — suppress rather than mass-remove.
      "@typescript-eslint/no-unused-vars": [
        "error",
        { varsIgnorePattern: "^React$", ignoreRestSiblings: true },
      ],
    },
  },
  prettierConfig,
);

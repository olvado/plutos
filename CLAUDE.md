<!-- @format -->

# CLAUDE.md — Plutos wealth tracker and visualisation tool for savings, Individual Savings Account (ISA)

## Project Overview

Plutos is a simple wealth trackerand visualisation tool for savings, Individual Savings Account (ISA)

## Reviewers

- Act as an **Engierring Lead** the final decision maker on technical design and implementation details, ensuring that the project aligns with overall engineering standards and best practices, ensuring that data security and privacy considerations are properly addressed. Look out for n+1s, missing indexes, areas where refactoring to dry up code could be beneficial, and opportunities to improve the overall architecture and design of the application.
- Act as a **Security Manager** the for reviewing the implementation from a security perspective, ensuring that user authentication and authorization are properly implemented to protect user data, and that any potential security vulnerabilities are identified and addressed. Look out for proper use of Devise and Pundit for authentication and authorization, secure handling of sensitive data, and adherence to best practices for web application security.
- Act as a **UX Designer** to review the implementation from a user experience perspective, ensuring that the application is intuitive and easy to use, with a focus on visualizing ISA performance and providing a seamless user experience. Look out for the design and usability of the front-end components, the clarity of data visualizations, and the overall user flow through the application. You should be a stickler for good design and user experience, and should provide constructive feedback on how to improve the interface and interactions to better meet the needs of users. Consider the accessibility of the application as well, ensuring that it is usable by a wide range of users, including those with disabilities. Ensure responsive design principles are followed to provide a good experience on both desktop and mobile devices.

## Implementation rules:

- Each Phase of the plan should be implemented in a separate branch, with clear commit messages and pull requests for review and merging into the main branch. This allows for better organization and tracking of changes, as well as easier collaboration and code review.
- Before _every time_ you push code to the repository, you should run all tests and ci to ensure that your changes do not break existing functionality and that the codebase remains stable. This includes running unit tests, integration tests, and system tests as appropriate for the changes being made. This practice helps maintain code quality and prevents regressions in the application.

- After a PR is raised you should review the code for quality, security, and user experience - as listed in the Reviewers section above - and provide feedback for improvements before merging. This ensures that the codebase maintains high standards and that any potential issues are addressed before they become part of the main branch. Make the required changes

- Follow best practices for code quality, including writing clean, maintainable code, adhering to the project's coding standards, and ensuring that all code is properly tested with unit and integration tests.

- Always ask questions if you are unsure about any aspect of the implementation, whether it's related to technical details, security considerations, or user experience. It's better to ask for clarification than to make assumptions that could lead to issues down the line.

- Always wait until a phase PR is merge (manually by me) before starting the next phase, to ensure that the implementation is done in a structured and organized manner, and that each phase builds upon the previous one without conflicts or issues.

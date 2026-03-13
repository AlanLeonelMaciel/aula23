# Repository Memory

Language:
typeScript

Framework:
NestJs

Architecture:
repository
clean architecture

Folders:

src/controllers → endpoints
src/services → business logic
src/repositories → database
src/entities -> models

Testing:
Jest
unit tests

Rules:

- Controllers must be thin
- Business logic in services
- Repositories handle DB access
- Models in the entities
# Repository Memory

Language:
TypeScript

Framework:
NestJS

Architecture:
Clean Architecture with Repository pattern

Folders:

* `src/domain` → Domain layer (business logic and entities)
* `src/application` → Application layer (use cases and interfaces)
* `src/infrastructure` → Infrastructure layer (database and external frameworks)
* `src/presentation` → Presentation layer (API endpoints)
* `src/controllers` → moved to `src/presentation/controllers`
* `src/services` → moved to `src/application/services`
* `src/repositories` → moved to `src/infrastructure/repositories`
* `src/entities` → moved to `src/domain/entities`

Testing:
Jest
Unit tests

Rules:

* Controllers must be thin
* Business logic in services
* Repositories handle DB access
* Models in the entities

New Technical Knowledge:

* Implemented path aliases in `tsconfig.json` for simplified imports across layers
* Configured ESLint and Prettier for code quality and formatting
* Created a base generic repository interface (`IRepository`) in the domain layer
* Set up a health check endpoint in the presentation layer

Path Aliases:

* `@domain/*`: `src/domain/*`
* `@application/*`: `src/application/*`
* `@infrastructure/*`: `src/infrastructure/*`
* `@presentation/*`: `src/presentation/*`

Recent Code Changes:

* Created a new NestJS project with Clean Architecture
* Set up the folder structure for the domain, application, infrastructure, and presentation layers
* Moved existing files to their respective layers
* Implemented a generic repository interface and a health check endpoint
* Configured ESLint and Prettier for code quality and formatting

Updated Package.json:

* Added scripts for linting and formatting
* Updated dependencies for NestJS and other required packages

Updated Tsconfig.json:

* Added path aliases for simplified imports
* Updated compiler options for the TypeScript compiler

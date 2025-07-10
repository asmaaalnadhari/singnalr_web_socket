# Real-Time Collaborative To-Do List

A Flutter application demonstrating a real-time, collaborative to-do list built with Clean Architecture (Domain / Data / Presentation) and SignalR for live updates.

---

## Table of Contents

1. [About](#about)
2. [Features](#features)
3. [Architecture Overview](#architecture-overview)
    - [Clean Architecture](#clean-architecture)
    - [Domain Layer](#domain-layer)
    - [Data Layer](#data-layer)
    - [Presentation Layer](#presentation-layer)
    - [SignalR Integration](#signalr-integration)
    - [State Management (BLoC)](#state-management-bloc)
4. [Project Structure](#project-structure)
5. [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Server Setup](#server-setup)
    - [Client Setup](#client-setup)
    - [Running the App](#running-the-app)
6. [Contributing](#contributing)
7. [License](#license)

---

## About

This project is a simple collaborative to-do list: everyone connected sees new tasks appear in real time. It uses:

- **Clean Architecture** to keep domain, data, and presentation concerns separate.
- **SignalR** (via `signalr_netcore`) for real-time communication.
- **BLoC** pattern (`flutter_bloc`) for state management in the UI.

---

## Features

- Add tasks and see them instantly on all connected clients.
- Clean, testable code with distinct layers.
- Easy to swap out the back-end or messaging protocol if needed.

---

## Architecture Overview

### Clean Architecture

- **Domain**: core business rules (entities, repository contracts, use-cases).
- **Data**: implementations of repository contracts (models, remote data source, repo).
- **Presentation**: BLoC + Flutter widgets (events, states, UI).

### Domain Layer

- **Entity**: `Task` (id, title, completed).
- **Repository Interface**: `TaskRepository` with `getTasks()` and `addTask()`.
- **Use-Cases**:
    - `GetTasksStream` returns a stream of tasks.
    - `AddTask` sends a new task title.

### Data Layer

- **Model**: `TaskModel` (extends `Task` + JSON (de)serialization).
- **Remote Data Source**: `TaskRemoteDataSourceImpl` connects to a SignalR hub, listens for `"TasksUpdated"` messages, and exposes a Dart `Stream<List<TaskModel>>`.
- **Repository Impl**: `TaskRepositoryImpl` bridges the domain contract to the remote data source.

### Presentation Layer

- **Events** (`task_event.dart`):
    - `LoadTasks`, `AddTaskEvent`, `TasksUpdatedEvent`.
- **States** (`task_state.dart`):
    - `TaskInitial`, `TaskLoading`, `TaskLoaded`, `TaskError`.
- **BLoC** (`task_bloc.dart`):
    - On `LoadTasks` → starts SignalR stream.
    - On new data → emits `TaskLoaded`.
    - On `AddTaskEvent` → calls use-case.
- **UI** (`task_page.dart`):
    - `BlocBuilder` renders loading, error, or list of tasks.
    - Input row to add new tasks.

### SignalR Integration

- Hub URL: `http://localhost:5000/tasksHub`
- Server broadcasts `TasksUpdated: List<Map<String, dynamic>>`.
- Client listens and updates its stream, triggering UI rebuilds.

### State Management (BLoC)

- Keeps UI code free of business logic.
- All side effects (SignalR connection, stream subscription) live in the BLoC.

---

## Project Structure

lib/
├─ domain/
│ ├─ entities/
│ │ └─ task.dart
│ ├─ repositories/
│ │ └─ task_repository.dart
│ └─ usecases/
│ ├─ get_tasks_stream.dart
│ └─ add_task.dart
│
├─ data/
│ ├─ models/
│ │ └─ task_model.dart
│ ├─ datasources/
│ │ └─ task_remote_data_source.dart
│ └─ repositories/
│ └─ task_repository_impl.dart
│
└─ presentation/
├─ bloc/
│ ├─ task_event.dart
│ ├─ task_state.dart
│ └─ task_bloc.dart
├─ pages/
│ └─ task_page.dart
└─ main.dart

# Data Flow Diagram


* User taps “Add”
  ↓
  Presentation → dispatches AddTaskEvent
  ↓
  TaskBloc → calls AddTask use-case
  ↓
  Use-case → calls TaskRepository.addTask()
  ↓
  RepositoryImpl → calls TaskRemoteDataSource.sendAddTask()
  ↓
  SignalR Hub → receives call → updates server list → broadcasts “TasksUpdated”
  ↑
  TaskRemoteDataSource._controller → emits new list
  ↑
  TaskBloc subscription → receives list → emits TasksUpdatedEvent → state=TaskLoaded
  ↑
  UI (BlocBuilder) → rebuilds with updated list


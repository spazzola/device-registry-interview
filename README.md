# 📱 Device Assignment App

A small Ruby on Rails application for managing device assignments within an organization.  
This project was implemented as part of a recruitment task.

## ✅ Features

- Users can assign a device to themselves.
- A device can only be assigned to one active user at a time.
- A user cannot assign a device that is already assigned to someone else.
- Only the user who assigned a device can return it.
- Once a user returns a device, they can never re-assign the same device again.

---

## 🧠 Business Logic

- Devices are uniquely identified by their `serial_number`.
- Assignment and return operations are handled using service objects:
  - `AssignDeviceToUser`
  - `ReturnDeviceFromUser`
- Returned devices are tracked internally; no flag is used, only ownership and timestamps.
- Invalid operations raise custom error classes (`AssigningError`, `RegistrationError`).

---

## ⚙️ Setup

### Requirements

- Ruby 3.3.3
- Rails 7.1.3.4
- SQLite (or PostgreSQL if configured)

### Installation

```bash
git clone https://github.com/YOUR_USERNAME/device-assignment-app.git
cd device-assignment-app
bundle install
bin/rails db:setup
```

###  Project Structure

- app/models/user.rb – basic user model
- app/models/device.rb – device model with assignment logic
- app/models/returns_history.rb - return history of devices
- app/services/assign_device_to_user.rb – device assignment logic
- app/services/return_device_from_user.rb – device return logic
- spec/services/ – tests for both services

###  License
This project is intended for demonstration purposes only.
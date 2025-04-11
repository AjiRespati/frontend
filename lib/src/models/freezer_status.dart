// Define the possible statuses
// Using an enum is generally better practice for fixed sets of values
// but sticking to strings as per your request.
enum FreezerStatus { active, broken, repairing, wasted, idle }

// Helper to get the string representation easily
extension MachineStatusExtension on FreezerStatus {
  String get displayName {
    switch (this) {
      case FreezerStatus.idle:
        return "Kembalikan ke distributor";
      case FreezerStatus.active:
        return "Aktif";
      case FreezerStatus.broken:
        return "Rusak";
      case FreezerStatus.repairing:
        return "Dalam perbaikan";
      case FreezerStatus.wasted:
        return "Rusak tidak bisa diperbaiki";
    }
  }
}

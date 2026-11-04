/// DEMO ONLY: replace with the user's emergency contacts from the backend.
class EmergencyContact {
  const EmergencyContact(this.name, this.phone);

  final String name;
  final String phone;
}

const demoEmergencyContacts = [
  EmergencyContact('Akhil (Brother)', '+91 98765 43210'),
  EmergencyContact('Amma', '+91 98765 67890'),
];

/// India's single emergency number.
const policeNumber = '112';

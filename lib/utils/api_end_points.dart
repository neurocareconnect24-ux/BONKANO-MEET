class APIEndPoints {
  static const String appConfiguration = 'app-configuration';
  static const String aboutPages = 'page-list';
  //Auth & User
  static const String register = 'register';
  static const String socialLogin = 'social-login';
  static const String login = 'login';
  static const String logout = 'logout';
  static const String changePassword = 'change-password';
  static const String forgotPassword = 'forgot-password';
  static const String userDetail = 'user-detail';
  static const String updateProfile = 'update-profile';
  static const String deleteUserAccount = 'delete-account';
  static const String getNotification = 'notification-list';
  static const String removeNotification = 'notification-remove';
  static const String clearAllNotification = 'notification-deleteall';
  static const String getPatientWallet = 'get-patient-wallet';
  static const String getWalletHistory = 'get-wallet-history';

  //home choose service api
  static const String getDashboard = 'dashboard-detail';
  static const String getSystemService = 'get-system-service';
  static const String getCategoryList = 'get-category-list';
  static const String getServiceList = 'get-service-list';
  static const String getServiceDetails = 'get-service-details';
  static const String getClinicList = 'get-clinic-list';
  static const String getClinicDetails = 'get-clinic-details';
  static const String getClinicGallery = 'get-clinic-gallery';
  static const String getDoctorList = 'get-doctor-list';
  static const String getDoctorDetails = 'get-doctor-details';
  static const String getTimeSlots = 'get-time-slots';
  static const String getAvailableDays = 'quick-booking/available-days';

  //Booking for Other
  static const String addPatient = 'add-patient-member';
  static const String otherMemberPatientList = 'other-members-list';
  static const String deleteOtherMember = 'delete-other_member';

  //booking api-list
  static const String getAppointments = 'appointment-list';
  static const String getEncounterList = 'encounter-list';
  static const String saveBooking = 'save-booking';
  static const String savePayment = 'save-payment';
  static const String updateStatus = 'update-status';
  static const String rescheduleBooking = 'reschedule-booking';

  //booking detail-api
  static const String getAppointmentDetail = 'appointment-detail';
  static const String downloadInvoice = 'download_invoice';

  //booking encounter detail
  static const String encounterDashboardDetail = 'encounter-dashboard-detail';

  //Review
  static const String saveRating = 'save-rating';
  static const String getRating = 'get-rating';
  static const String deleteRating = 'delete-rating';

  //Video Call
  static const String getAgoraToken = 'get-agora-token';

  //Health Space
  static const String getMedicalHistory = 'get-medical-history';
  static const String saveMedicalHistory = 'save-medical-history';
  static const String deleteMedicalHistory = 'delete-medical-history';
  static const String getAllergies = 'get-allergies';
  static const String saveAllergy = 'save-allergy';
  static const String deleteAllergy = 'delete-allergy';
  static const String getTreatments = 'get-treatments';
  static const String saveTreatment = 'save-treatment';
  static const String deleteTreatment = 'delete-treatment';
  static const String getVaccinations = 'get-vaccinations';
  static const String saveVaccination = 'save-vaccination';
  static const String deleteVaccination = 'delete-vaccination';
  static const String getLabResults = 'get-lab-results';
  static const String saveLabResult = 'save-lab-result';
  static const String deleteLabResult = 'delete-lab-result';
  static const String getMedicalDocuments = 'get-medical-documents';
  static const String saveMedicalDocument = 'save-medical-document';
  static const String deleteMedicalDocument = 'delete-medical-document';
  static const String getMeasurements = 'get-measurements';
  static const String saveMeasurement = 'save-measurement';
  static const String deleteMeasurement = 'delete-measurement';
  static const String getEmergencyContacts = 'get-emergency-contacts';
  static const String saveEmergencyContact = 'save-emergency-contact';
  static const String deleteEmergencyContact = 'delete-emergency-contact';

  //Chat
  static const String getConversations = 'get-conversations';
  static const String getMessages = 'get-messages';
  static const String sendMessage = 'send-message';
  static const String createConversation = 'create-conversation';

  //Vendor
  static const String updateService = 'update-service';
  static const String addServiceTraining = 'service-training';
  static const String serviceList = 'service-list';
  static const String deleteService = 'delete-service';
  static const String getCategory = 'category-list';
  static const String addService = 'service';
}

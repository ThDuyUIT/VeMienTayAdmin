class Ticket {
  late String keyTicket;
  late String idAccount;
  late String idTransition;
  late String priceTotal;
  late String methodPayment;
  late String statusPayment;
  late String statusTicket;

  Ticket(
      {required this.keyTicket,
      required this.idAccount,
      required this.idTransition,
      required this.priceTotal,
      required this.methodPayment,
      required this.statusPayment,
      required this.statusTicket});
}

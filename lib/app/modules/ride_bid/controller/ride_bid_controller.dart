import 'package:cabifyit/app/data/services/booking_service.dart';
import 'package:cabifyit/app/data/services/socket_service.dart';
import 'package:get/get.dart';

class RideBidController extends GetxController {
  var bookingId = ''.obs;
  var amount = ''.obs;
  var km = ''.obs;
  var isCancelling = false;
  BookingService bookingService = BookingService();
  List bids = [];


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    List args = Get.arguments ?? [];
    if(args.isNotEmpty) {
      bookingId.value = args[0];
      amount.value = args[1];
      km.value = args[2];
    }
    getRideStatus();
  }

  cancelRide({required bool goBack, bool isAccepted = false}) async {
    if(isAccepted) {
      SocketService().socket?.off("place-bid-event");
      Get.back(result: goBack);
      return;
    }
    if (isCancelling) return;
    isCancelling = true;
    var body = {
      'booking_id': bookingId.value
    };
    var result = await bookingService.cancelRide(body: body);
    isCancelling = false;
    if(result != null) {
      SocketService().socket?.off("place-bid-event");
      Get.back(result: goBack);
    }
  }

  getRideStatus() {
    SocketService().socket?.on("user-ride-status-event", (data) {
      if(data != null && data['status'] == 'accept_ride') {
        cancelRide(goBack: true, isAccepted: true);
      }
    },);

    SocketService().socket?.on("place-bid-event", (data) {
      var id = data['bid_id'];
      var time = DateTime.now();
      data.addAll({"time": time});
      bids.add(data);
      update();

      Future.delayed(const Duration(seconds: 10), () {
        bids.removeWhere((element) => element['bid_id'] == id);
        update();
      });
    },);
  }

  changeStatus({required bidId, required status}) async {
    var body = {
      "bid_id": bidId,
      "status": status
    };
    var result = await bookingService.changeBidStatus(body: body);
    if(result != null) {
      if(status == "accepted") {
        cancelRide(goBack: true, isAccepted: true);
      } else {
        bids.removeWhere((element) => (element['bid_id']).toString() == bidId);
        update();
      }
    }
  }
}
abstract class Validator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements Validator {
  @override
  bool isValid(String value) {
    if (value.isEmpty) {
      return false;
    }
    return value.isNotEmpty;
  }
}

class EmailValidator implements Validator {
  @override
  bool isValid(String value) {
    String pattern =
        r'^(?=(.{1,64}@.{1,255}))([-+%_a-zA-Z0-9]{1,64}(\.[-+%_a-zA-Z0-9][^.]{0,}){0,})@([a-zA-Z0-9_]{0,63}(\.[a-zA-Z0-9-]{0,}){0,}[^.](?!.web)(\.[a-zA-Z]{2,6}){1,4})$';
    RegExp regex = RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }
}

class FieldValidators {
  final Validator emailValidator = EmailValidator();
  final String errorTextEmail = '';
  var emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9-]+\.)+[a-zA-Z]{2,}))$');
  var panCardRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
  var ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
  static Validator stringValidator = NonEmptyStringValidator();
  final String errorTextString = 'Text can\'t be empty';
  static String commonBlank = "can't be empty";
  isValidEmail(String value) {
    value = value.trim();
    if (!stringValidator.isValid(value)) {
      return 'Email $commonBlank';
    } else if (!value.contains(emailRegex)) {
      return 'Please enter a valid email address';
    } else {
      return null;
    }
  }

  isValidIfsc(String value) {
    value = value.trim();
    if (!stringValidator.isValid(value)) {
      return 'IFSC Code $commonBlank';
    } else if (!value.contains(ifscRegex)) {
      return 'Please enter a valid IFSC Code';
    } else {
      return null;
    }
  }

  isValidPanCard(String value) {
    value = value.trim();
    if (!stringValidator.isValid(value)) {
      return 'Pan card $commonBlank';
    } else if (!panCardRegex.hasMatch(value)) {
      return 'Please enter a valid Pan Card Number';
    } else {
      return null;
    }
  }

  String? isValidLoginPassword(String value) {
    return validate(value, 'Password');
  }

  static String? validate(String value, String labelName) {
    if (!stringValidator.isValid(value)) {
      return "$labelName $commonBlank";
    } else {
      return null;
    }
  }

  String? isValidName(String value) {
    value = value.trim();
    if (validate(value, 'Name') == null) {
      bool allLetters = value.contains(RegExp(r'[A-Za-z ]'));
      return !allLetters
          ? 'Name should contain only alphabets'
          : value.length < 2
          ? 'Name must have atleast 2 characters'
          : value.length > 50
          ? 'Name should not be more than 50 character'
          : null;
    } else {
      return validate(value, 'Name');
    }
  }

  String? isValidAccountNumber(String value) {
    value = value.trim();
    if (validate(value, 'Account Number') == null) {
      return value.length < 9 || value.length > 50
          ? 'Account Number must coints 9 to 18 digits'
          : null;
    } else {
      return validate(value, 'Account Number');
    }
  }

  String? isValidLast4Digit(String value) {
    if (validate(value, 'Card Number') == null) {
      return value.length != 4 ? 'Please Enter Last 4 Digit of Card' : null;
    } else {
      return validate(value, 'Card Number');
    }
  }

  String? isValidOtpCode(String value) {
    if (validate(value, 'OTP') == null) {
      return value.length != 4 ? 'OTP must contain 4 digits' : null;
    } else {
      return validate(value, 'OTP');
    }
  }

  String? isValidPrice(String value) {
    if (validate(value, 'Price') == null) {
      return null;
    } else {
      return validate(value, 'Price');
    }
  }

  String? isValidDesc(String value) {
    value = value.trim();
    if (validate(value, 'Description') == null) {
      return value.length < 2
          ? 'Description must have atleast 10 characters'
          : value.length > 10000
          ? 'Description should not be more than 10000 character'
          : null;
    } else {
      return validate(value, 'Description');
    }
  }

  String? isValidFeed(String value) {
    value = value.trim();
    if (validate(value, 'Feedback') == null) {
      return value.length < 5
          ? 'Feedback must have atleast 5 characters'
          : value.length > 500
          ? 'Feedback should not be more than 500 character'
          : null;
    } else {
      return validate(value, 'Feedback');
    }
  }

  String? isValidPhoneNumber(String value) {
    if (validate(value, 'Mobile Number') == null) {
      if(value.isEmpty) {
        return "Mobile number can't be empty";
      } else if (value[0] == '0') {
        return 'Mobile number should not start with zero';
      } else if (value == '(000) 000-0000') {
        return 'Invalid Mobile number';
      } else if(!RegExp(r"(^(?:[+0]9)?[0-9]{10}$)").hasMatch(value)) {
        return 'Please enter a valid Mobile Number';
      } else {
        return null;
      }
    } else {
      return validate(value, 'Mobile Number');
    }
  }

  String? isValidUrl(String value) {
    value = value.trim();

    if (validate(value, 'URL') == null) {
      value = value.toLowerCase();
      String patternYoutube =
          r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$';
      RegExp regExp = RegExp(patternYoutube);
      return (!regExp.hasMatch(value))
          ? 'Enter a valid URL must start with https://'
          : null;
    } else {
      // TODO: implement isValid
      return validate(value, 'URL');
    }
  }

  String? isValidLastName(String value) {
    value = value.trim();
    if (validate(value, 'Last Name') == null) {
      String patternName = r'^[A-Za-z\s]+$';
      RegExp regExp = RegExp(patternName);
      if (regExp.hasMatch(value)) {
        return value.length < 3
            ? 'Last Name must have atleast 3 characters'
            : value.length > 50
            ? 'Last Name should not be more than 50 character'
            : null;
      } else {
        return 'Last Name must contain only alphabets';
      }
    } else {
      return validate(value, 'Last Name');
    }
  }

  String? isValidFirstName(String value) {
    value = value.trim();
    if (validate(value, 'First Name') == null) {
      String patternName = r'^[A-Za-z\s]+$';
      RegExp regExp = RegExp(patternName);
      if (regExp.hasMatch(value)) {
        return value.length < 3
            ? 'First Name must have atleast 3 characters'
            : value.length > 50
            ? 'First Name should not be more than 50 character'
            : null;
      } else {
        return 'First Name must contain only alphabets';
      }
    } else {
      return validate(value, 'First Name');
    }
  }

  String? isValidAmountEntered(String value) {
    value = value.trim();
    if (validate(value, 'Amount') == null) {
      return value.isEmpty ? 'Amount must be entered' : null;
    } else {
      return validate(value, 'Amount');
    }
  }

  String? isValidPassword(String value) {
    value = value.trim();

    if (value.isEmpty || value == "") {
      return "Password field must not be empty";
    } else if (value.length >= 6) {
      return null;
    } else {
      return "Your password must be at least 6 characters.";
    }
  }

  String? isValidOTP(String value) {
    value = value.trim();
    if (validate(value, 'OTP') == null) {
      return value.isEmpty ? '*' : null;
    } else {
      return validate(value, 'Amount');
    }
  }

  String? isValidNull(String? value) {
    return null;
  }
}

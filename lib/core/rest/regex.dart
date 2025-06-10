Pattern pattern = r'^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,}$';
RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,}$');
RegExp emailPhoneRegex = RegExp(r'^(?:\d{11}|\w+@\w+\.\w{2,3})$');
RegExp numbersRegex = RegExp(r'^[0-9]+$');
RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
RegExp emailRegexNew = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
RegExp phoneNumberRegex = RegExp(r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$');
// RegExp phoneNumberRegex1 = RegExp(r'(^(?:[+0]9)?[0-9]{9,12}$)');
RegExp phoneNumberRegex1 = RegExp(r'^(\+?[1-9]\d{0,2})?[\s-]?(\(?\d{1,4}\)?[\s-]?)?(\d{1,4}[\s-]?\d{1,4}[\s-]?\d{1,9})$');
// RegExp webSiteRegex = RegExp( r"(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z]{2,}(\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,})?\/[a-zA-Z0-9]{2,}|((https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z]{2,}(\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,})?)|(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z0-9]{2,}\.[a-zA-Z0-9]{2,}\.[a-zA-Z0-9]{2,}(\.[a-zA-Z0-9]{2,})?", caseSensitive: false);
RegExp webSiteRegex = RegExp(
    r'((http|https):\/\/)?(www\.)?[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}(:\d+)?(\/[\w\/\-\?\=\#\&\.]*)?|[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}'  ,
    caseSensitive: false
);





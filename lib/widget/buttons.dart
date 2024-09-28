import 'package:flutter/material.dart';

class Buttons {
  defaultButtons({isLoading, title, action}) {
    return SizedBox(
      height: 53,
      width: double.infinity,
      child: ElevatedButton(
          onPressed: action,
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xff009933),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                  )
                : Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "PoppinsMeds"),
                  ),
          )),
    );
  }

  borderButtons({title, action}) {
    return SizedBox(
      height: 53,
      width: double.infinity,
      child: ElevatedButton(
          onPressed: action,
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xff009933)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                  color: Color(0xff009933),
                  fontSize: 16,
                  fontFamily: "PoppinsMeds"),
            ),
          )),
    );
  }

  cancelButtons({title, action}) {
    return SizedBox(
      height: 53,
      width: double.infinity,
      child: ElevatedButton(
          onPressed: action,
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xffF5F5F5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                  color: Color(0xff828282),
                  fontSize: 16,
                  fontFamily: "PoppinsMeds"),
            ),
          )),
    );
  }

  dangerButtons({title, action, isLoading}) {
    return SizedBox(
      height: 53,
      width: double.infinity,
      child: ElevatedButton(
          onPressed: action,
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xffDE4841),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                  )
                : Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "PoppinsMeds"),
                  ),
          )),
    );
  }
}

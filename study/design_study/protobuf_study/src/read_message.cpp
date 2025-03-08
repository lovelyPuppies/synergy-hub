#include "addressbook.pb.h"
#include <fstream>
#include <iostream>
using namespace std;

// Iterates though all people in the AddressBook and prints info about them.
void ListPeople(const tutorial::AddressBook &address_book) {
  for (int i = 0; i < address_book.people_size(); i++) {
    const tutorial::Person &person = address_book.people(i);

    cout << "Person ID: " << person.id() << endl;
    cout << "  Name: " << person.name() << endl;
    if (person.has_email()) {
      cout << "  E-mail address: " << person.email() << endl;
    }

    for (int j = 0; j < person.phones_size(); j++) {
      const tutorial::Person::PhoneNumber &phone_number = person.phones(j);

      switch (phone_number.type()) {
      case tutorial::Person::PHONE_TYPE_MOBILE:
        cout << "  Mobile phone #: ";
        break;
      case tutorial::Person::PHONE_TYPE_HOME:
        cout << "  Home phone #: ";
        break;
      case tutorial::Person::PHONE_TYPE_WORK:
        cout << "  Work phone #: ";
        break;
      }
      cout << phone_number.number() << endl;
    }
  }
}

// Main function:  Reads the entire address book from a file and prints all
//   the information inside.
int main(int argc, char *argv[]) {
  // Verify that the version of the library that we linked against is
  // compatible with the version of the headers we compiled against.
  GOOGLE_PROTOBUF_VERIFY_VERSION;

  if (argc != 2) {
    cerr << "Usage:  " << argv[0] << " ADDRESS_BOOK_FILE" << endl;
    return -1;
  }

  tutorial::AddressBook address_book;

  {
    // Read the existing address book.

    fstream input(argv[1], ios::in | ios::binary);
    cerr << "Debug: First byte in file: " << input.peek() << endl;
    cout << "??1" << endl;
    if (!address_book.ParseFromIstream(&input)) {
      cerr << "Failed to parse address book." << endl;
      return -1;
    }
    cout << "??2" << endl;
  }

  ListPeople(address_book);

  // Optional:  Delete all global objects allocated by libprotobuf.
  // ❗
  google::protobuf::ShutdownProtobufLibrary();

  return 0;
}
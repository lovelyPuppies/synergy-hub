/*
gcc mknod.c -o mknod.out


./mknod
# >> mknod(): Permission denied


//
man 3 perror


sudo ./mknod
# When "S_IRWXU | S_IRWXG | S_IRWXO | S_IFCHR"
ls -l /dev/test_dev
#   >> ❔ crwxr-xr-x 1 root root 240, 1 Dec 13 11:49 /dev/test_dev
#

rm-linux-gnueabihf-gcc mknod.c -o mknod.out
cp mknod /nfs/drivers/s


*/
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int main(void) {
  int ret;
  ret = mknod("/dev/test_dev", S_IRWXU | S_IRWXO | S_IFCHR, (240 << 8) | 1);
  if (ret < 0) {
    perror("mknod()");
    return -ret;
    // return ENOMEM;
    // return EINVAL;
  }
  ret = open("/dev/test_dev", O_RDWR);
  if (ret < 0) {
    perror("open()");
    return -ret;
  }

  return 0;
}

/*
 * ❓ PERMISSION GROUPS:
 * These define the scope of permissions for different entities.
 *
 * S: Set
 *    Indicates a flag for setting file properties or permissions.
 * I: Input/Output
 *    Refers to operations involving data reading or writing.
 * R: Read
 *    Grants permission to read the file or directory.
 * W: Write
 *    Grants permission to write to the file or modify it.
 * X: Execute
 *    Grants permission to execute a file or access a directory.
 *
 * U: User
 *    Refers to the file owner.
 * G: Group
 *    Refers to the group associated with the file.
 * O: Others
 *    Refers to users who are not the owner or in the group.
 */

/*
 * ❓ FILE TYPES:
 * These constants define the type of file being represented.
 *
 * S_IFCHR: Character Device
 *    A device that handles data as characters (e.g., keyboard, mouse).
 * S_IFREG: Regular File
 *    A standard file (e.g., text files, executables).
 * S_IFDIR: Directory
 *    A folder that contains other files or directories.
 * S_IFBLK: Block Device
 *    A device that handles data in blocks (e.g., hard disks, USB storage).
 * S_IFIFO: FIFO or Pipe
 *    A special file used for interprocess communication.
 * S_IFSOCK: Socket File
 *    A file for network communication.
 * S_IFLNK: Symbolic Link
 *    A file that is a reference (link) to another file or directory.
 */

/*
 * ❓ FILE OPEN MODES:
 * These constants specify how a file or device should be opened.
 *
 * O_RDWR: Read/Write
 *    Opens a file for both reading and writing.
 *    O: Open
 *       Indicates the operation of opening a file or device.
 *    R: Read
 *       Grants permission to read data from the file.
 *    D: Write
 *       Grants permission to write data to the file.
 *    WR: Read/Write
 *       Combines reading and writing permissions.
 *
 * Other Modes:
 * O_RDONLY: Opens a file in read-only mode.
 * O_WRONLY: Opens a file in write-only mode.
 * O_CREAT: Creates the file if it does not exist.
 * O_APPEND: Appends data to the end of the file.
 * O_TRUNC: Truncates the file, clearing its contents upon opening.
 */

/*
 * FILE TYPES (S_IF~ Constants):
 * These constants define the type of file or special file being represented.
 * Each part of the constant's name indicates a specific aspect of its
 * functionality.
 *
 * S: Set
 *    Indicates that this is a setting or flag used to define a file type.
 * IF: Identifier for File Type
 *    Specifies that the following characters identify the file's type.
 * ~ (e.g., CHR, REG, DIR):
 *    Defines the specific type of file. Below are the common file types:
 *
 * S_IFCHR: Character Device
 *    - S: Set
 *    - IF: Identifier for File Type
 *    - CHR: Character Device
 *      Represents devices that handle data as a stream of characters.
 *      Examples: Keyboard, Mouse, Serial Ports.
 *
 * S_IFREG: Regular File
 *    - S: Set
 *    - IF: Identifier for File Type
 *    - REG: Regular File
 *      Standard files such as text files, executables, or binary files.
 *
 * S_IFDIR: Directory
 *    - S: Set
 *    - IF: Identifier for File Type
 *    - DIR: Directory
 *      A container for files and subdirectories.
 *
 * S_IFBLK: Block Device
 *    - S: Set
 *    - IF: Identifier for File Type
 *    - BLK: Block Device
 *      Devices that transfer data in fixed-size blocks.
 *      Examples: Hard Drives, USB Drives.
 *
 * S_IFIFO: FIFO (First In, First Out) or Pipe
 *    - S: Set
 *    - IF: Identifier for File Type
 *    - FIFO: FIFO or Pipe
 *      A special file used for interprocess communication (IPC).
 *
 * S_IFSOCK: Socket File
 *    - S: Set
 *    - IF: Identifier for File Type
 *    - SOCK: Socket
 *      Represents a file used for network communication.
 *
 * S_IFLNK: Symbolic Link
 *    - S: Set
 *    - IF: Identifier for File Type
 *    - LNK: Link
 *      A file that serves as a reference (link) to another file or directory.
 */

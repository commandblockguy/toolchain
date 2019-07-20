/**
 * @file
 * @author commandblockguy
 * @brief USB Serial Host Driver
 *
 * This library can be used to communicate with USB serial devices.
 *
 */

#ifndef H_SRLDRVCE
#define H_SRLDRVCE

#include <stddef.h>
#include <stdint.h>
#include <usbdrvce.h>

#ifdef __cplusplus
extern "C" {
#endif

enum srl_DeviceType {
    SRL_HOST = -1,   /**< Calc is acting as a device */
    SRL_UNKNOWN = 0, /**< Incompatible or non-serial device */
    SRL_CDC,         /**< CDC device */
    SRL_FTDI         /**< FTDI device */
};

typedef uint8_t srl_deviceType_t;

typedef struct srl_Device {
    usb_device_t dev;       /**< USB device */
    usb_endpoint_t in       /**< USB bulk in endpoint */
    usb_endpoint_t out;     /**< USB bulk out endpoint */
    srl_deviceType_t type;  /**< Device type */
    char *readBuf;          /**< Pointer to the read buffer */
    size_t readBufSize;     /**< Size of the read buffer */
    char *readBufStart;     /**< First byte with data in the read buffer */
    char *readBufEnd;       /**< Last byte with data in the read buffer */
    char *readBufBreak;     /**< Last byte before the buffer "loops" */
    char *writeBuf;         /**< Pointer to the write buffer */
    size_t writeBufSize;    /**< Size of the write buffer */
    char *writeBufStart;    /**< First byte with data in the write buffer */
    char *writeBufEnd;      /**< Last byte with data in the write buffer */
} srl_device_t;

enum charFormat {
    SRL_SB_1 = 0,
    SRL_SB_1_5,
    SRL_SB_2
};

enum parityType {
    SRL_PARITY_NONE = 0,
    SRL_PARITY_ODD,
    SRL_PARITY_EVEN,
    SRL_PARITY_MARK,
    SRL_PARITY_SPACE
};

typedef struct srl_LineCoding {
    uint32_t rate;      /**< Baud rate */
    uint8_t charFormat; /**< Number of stop bits (generally 1) */
    uint8_t parityType; /**< Parity type (generally none) */
    uint8_t dataBits;   /**< Number of data bits (generally 8) */
} srl_lineCoding_t;


/**
 * Initializes a serial device and assigns it a buffer.
 * The buffer must be at least 128 bytes long, but a size of 512 bytes is recommended.
 * @param dev USB device to be used as a serial device.
 * @param buf The buffer's address.
 * @return USB_SUCCESS on success, otherwise an error.
 */
usb_error_t srl_Init(srl_device_t *srl, usb_device_t dev, void *buf);

/**
 * Get the type of a serial device.
 * @return SRL_UNKNOWN if not a compatible serial device, otherwise the device type.
 */
srl_deviceType_t srl_GetType(usb_device_t dev);

/**
 * Set the baud rate of the device.
 * @param rate Baud rate.
 * @return USB_SUCCESS on success, otherwise an error.
 */
usb_error_t srl_SetRate(srl_device_t *srl, uint24_t rate);

/**
 * Get the baud rate of the device.
 * @return Baud rate, or 0 on error.
 */
uint24_t srl_GetRate(srl_device_t *srl);

/**
 * Set the device line coding.
 * @param coding Line coding to use.
 * @return USB_SUCCESS on success, otherwise an error.
 */
usb_error_t srl_SetCoding(srl_device_t *srl, const srl_lineCoding_t *coding);

/**
 * Get the device's current line coding.
 * @param coding Buffer to store the device's current line coding.
 * @return USB_SUCCESS on success, otherwise an error.
 */
usb_error_t srl_GetCoding(srl_device_t *srl, srl_lineCoding_t *coding);

/**
 * Get the number of bytes available in the input buffer.
 */
size_t srl_Available(srl_device_t *srl);

/**
 * Performs a non-blocking read of data.
 * If there are less than length bytes available, all available data will be read.
 * @param buffer Buffer that data is read in to.
 * @param length Maximum amount of data to read.
 * @return The amount of data actually read.
 */
size_t srl_Read(srl_device_t *srl, void *buffer, size_t length);

/**
 * Performs a non-blocking write of data.
 * @param buffer Data to write.
 * @param length Amount of data to write.
 * @return The amount of data actually written.
 */
size_t srl_Write(srl_device_t *srl, const void *buffer, size_t length);

/**
 * Performs a blocking read of data.
 * If there are less than length bytes available, the function will wait until
 * the timeout is exceeded or length bytes become available.
 * @param buffer Buffer that data is read in to.
 * @param length Amount of data to read.
 * @param timeout Timeout in milliseconds, or 0 for no timeout.
 * @return The amount of data read.
 */
size_t srl_Read_Blocking(srl_device_t *srl, void *buffer, size_t length, uint24_t timeout);

/**
 * Performs a blocking write of data.
 * The function will wait until the timeout is exceeded or all data is transmitted.
 * @param buffer Data to write.
 * @param length Amount of data to write.
 * @param timeout Timeout in milliseconds, or 0 for no timeout.
 * @return The amount of data actually written.
 */
size_t srl_Write_Blocking(srl_device_t *srl, const void *buffer, size_t length, uint24_t timeout);

#ifdef __cplusplus
}
#endif

#endif

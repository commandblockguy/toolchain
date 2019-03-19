/**
 * @file
 * @author commandblockguy
 * @brief USB Serial Host Driver
 */

#ifndef H_SRLDRVCE
#define H_SRLDRVCE

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Character format.
 *
 * The number of stop bits used
 *
 */
enum charFormat {
	sb_1 = 0, /**< 1 stop bit */
	sb_1_5,   /**< 1.5 stop bits */
	sb_2      /**< 2 stop bits */
};

/**
 * @brief Parity bit type.
 *
 * (https://en.wikipedia.org/wiki/Parity_bit)
 */
enum parityType {
	parity_none = 0, /**< No parity bit */
	parity_odd,      /**< Odd parity */
	parity_even,     /**< Even parity */
	parity_mark,     /**< Mark parity */
	parity_space     /**< Space parity */
};

/**
 * @brief Line coding format.
 *
 * Many devices use {9600,0,0,8}
 *
 */
typedef struct {
	uint32_t rate;      /**< Data terminal rate in bits per second */
	uint8_t charFormat; /**< Character format */
	uint8_t parityType; /**< Parity type */
	uint8_t dataBits;   /**< Number of data bits: 5, 6, 7, 8, or 16 */
} lineCoding_t;

/**
 * Initialize the serial device
 *
 * @returns 0 if initialization failed
 */
uint8_t srl_Init();

/**
 * Set the device line coding
 *
 * @param lc Pointer to line coding structure
 */
void srl_SetCoding(lineCoding_t* lc);

/**
 * Get the line coding being used by the device
 *
 * @returns Line coding structure
 */
lineCoding_t srl_GetCoding(void);

/**
 * @brief Send data over serial
 * 
 * @param buf Pointer to data to send
 * @param len Number of bytes to send
 */
void srl_Write(void* buf, uint24_t len);

/**
 * @brief Send a string over serial
 * 
 * The null terminator is included
 *
 * @param str String to send
 */
#define srl_WriteString(str) srl_Write((str), strlen((str)) + 1)

/**
 * Send a single byte over serial
 *
 * @param byte Byte to send
 */
#define srl_WriteByte(byte) srl_Write(&(byte), 1)

/**
 * Receive data from serial
 *
 * @param buf Buffer to store received data
 * @param len Number of bytes to receive
 * @returns Number of bytes actually received
 */
uint24_t srl_Read(void* buf, uint24_t len);

/**
 * Receive a byte from serial
 *
 * @returns Received byte
 */
char srl_ReadByte(void);

/**
 * Check if there are any bytes avaiable to be read
 *
 * @returns true if there are bytes available
 */
bool srl_Available(void);

/**
 * Wait for bytes to become available
 *
 */
#define srl_Await() while(!srl_Available())

/**
 * Deinitialize the serial device
 */
void srl_Deinit();

#ifdef __cplusplus
}
#endif

#endif

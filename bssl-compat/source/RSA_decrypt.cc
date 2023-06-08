#include <openssl/rsa.h>
#include <ossl.h>


/*
 * https://github.com/google/boringssl/blob/cd0b767492199a82c7e362d1a117e8c3fef6b943/include/openssl/rsa.h#L259
 * https://www.openssl.org/docs/man3.0/man3/RSA_private_decrypt.html
 */
extern "C" int RSA_decrypt(RSA *rsa, size_t *out_len, uint8_t *out, size_t max_out, const uint8_t *in, size_t in_len, int padding) {
  size_t min_out = RSA_size(rsa);

  switch(padding) {
    case RSA_NO_PADDING: {
      break;
    }
    case RSA_PKCS1_PADDING: {
      min_out -= 11;
      break;
    }
    case RSA_PKCS1_OAEP_PADDING: {
      min_out -= 42;
      break;
    }
    default: {
      return 0; // Unexpected padding value
    }
  }

  if (max_out < min_out) {
    return 0; // out buffer too small
  }

  int ret = ossl.ossl_RSA_private_decrypt(in_len, in, out, rsa, padding);
  if (ret == -1) {
    return 0;
  }

  *out_len = ret;

  return 1;
}
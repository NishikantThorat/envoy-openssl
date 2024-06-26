cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

include(FetchContent)
include(GoogleTest)

if(POLICY CMP0135)
  cmake_policy(SET CMP0135 NEW)
endif()

set(OPENSSL_URL      https://github.com/openssl/openssl/archive/refs/tags/openssl-3.0.13.tar.gz)
set(OPENSSL_URL_HASH e74504ed7035295ec7062b1da16c15b57ff2a03cd2064a28d8c39458cacc45fc)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# Produce a compilation database in json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project(bssl-compat VERSION 0.1 LANGUAGES C CXX)

include(cmake/boringssl.cmake)
include(cmake/openssl.cmake)

add_subdirectory(prefixer)
add_custom_command(DEPENDS prefixer OpenSSL
                   COMMENT "Prefixing OpenSSL files"
                   OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/source/ossl.c
                          ${CMAKE_CURRENT_BINARY_DIR}/include/ossl.h
                          ${CMAKE_CURRENT_BINARY_DIR}/include/ossl/openssl/err.h
                   COMMAND prefixer --src-path "${OPENSSL_INCLUDE_DIR}"
                                    --src-incl "openssl/*.h"
                                    --src-skip "openssl/asn1_mac.h"
                                    --src-skip "openssl/opensslconf-*.h"
                                    --output "${CMAKE_CURRENT_BINARY_DIR}"
                                    --prefix ossl)
add_custom_target(ossl-gen DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/include/ossl.h)
add_dependencies(bssl-gen ossl-gen) # generate ossl headers before bssl headers

# custom mappings
add_library(bssl-compat STATIC
  source/ASN1_TIME_free.cc
  source/BASIC_CONSTRAINTS_free.cc
  source/BASIC_CONSTRAINTS_new.cc
  source/bio_meth_map.cpp
  source/BIO_free.cc
  source/BIO_mem_contents.cc
  source/BIO_new_bio_pair.cc
  source/BIO_new.cc
  source/BIO_pending.cc
  source/BIO_printf.cc
  source/BIO_read_asn1.c
  source/BIO_s_mem.cc
  source/BIO_s_socket.cc
  source/BIO_snprintf.cc
  source/BIO_vfree.cc
  source/BN_cmp_word.cc
  source/BN_bn2hex.cc
  source/BN_bin2bn.cc
  source/c2i_ASN1_INTEGER.cc
  source/CRYPTO_BUFFER_free.c
  source/CRYPTO_BUFFER.h
  source/CRYPTO_BUFFER_new.c
  source/d2i_GENERAL_NAME.cc
  source/ECDSA_do_verify.cc
  source/ECDSA_sign.cc
  source/EC_KEY_check_fips.cc
  source/EC_KEY_parse_private_key.cc
  source/EC_KEY_set_public_key_affine_coordinate.cc
  source/ED25519_verify.cc
  source/err.cc
  source/EVP_DecodeBase64.c
  source/EVP_DecodedLength.c
  source/EVP_DigestVerifyFinal.cc
  source/EVP_DigestSignFinal.cc
  source/EVP_MD_CTX_move.cc
  source/EVP_parse_public_key.cc
  source/EVP_PKEY_get0_EC_KEY.cc
  source/EVP_PKEY_get0_RSA.cc
  source/EVP_PKEY_get1_EC_KEY.cc
  source/EVP_PKEY_get1_RSA.cc
  source/EVP_PKEY_id.cc
  source/ext_SSL_get_all_async_fds.c
  source/FIPS_mode.cc
  source/GENERAL_NAME_free.cc
  source/GENERAL_NAME_new.cc
  source/GENERAL_NAMES_free.cc
  source/GENERAL_NAMES_new.cc
  source/GENERAL_SUBTREE_free.cc
  source/GENERAL_SUBTREE_new.cc
  source/HMAC_Init_ex.cc
  source/i2d_X509.c
  source/i2d_X509_PUBKEY.cc
  source/iana_2_ossl_names.cc
  source/internal.h
  source/log.c
  source/log.h
  source/NAME_CONSTRAINTS_free.cc
  source/NAME_CONSTRAINTS_new.cc
  source/ossl.c
  source/override.h
  source/override.cc
  source/PEM_read_bio_PrivateKey.cc
  source/PEM_read_bio_RSAPrivateKey.c
  source/PEM_read_bio_X509.cc
  source/PEM_read_bio_X509_AUX.cc
  source/PEM_read_bio_X509_CRL.cc
  source/PEM_read_bio_PUBKEY.cc
  source/PEM_write_bio_X509.cc
  source/PEM_X509_INFO_read_bio.cc
  source/PKCS12_get_key_and_certs.cc
  source/PKCS12_parse.cc
  source/PKCS12_verify_mac.cc
  source/RAND_bytes.cc
  source/RSA_check_fips.cc
  source/RSA_decrypt.cc
  source/RSA_encrypt.cc
  source/RSA_generate_key_ex.cc
  source/RSA_private_key_from_bytes.cc
  source/RSA_public_key_from_bytes.cc
  source/RSA_sign_pss_mgf1.cc
  source/SHA256.cc
  source/SSL_add_file_cert_subjects_to_stack.cc
  source/SSL_CIPHER_get_kx_nid.cc
  source/SSL_CIPHER_get_min_version.cc
  source/SSL_CIPHER_get_prf_nid.cc
  source/SSL_CIPHER_get_rfc_name.cc
  source/SSL_CTX_get_ciphers.cc
  source/SSL_CTX_get_client_CA_list.cc
  source/SSL_CTX_get_max_proto_version.cc
  source/SSL_CTX_get_min_proto_version.cc
  source/SSL_CTX_get_ex_new_index.cc
  source/SSL_CTX_get_session_cache_mode.cc
  source/SSL_CTX_sess_set_new_cb.cc
  source/SSL_CTX_set_alpn_select_cb.cc
  source/SSL_CTX_set_cert_verify_callback.cc
  source/SSL_CTX_set_client_CA_list.cc
  source/SSL_CTX_set_custom_verify.cc
  source/SSL_CTX_set_next_protos_advertised_cb.cc
  source/SSL_CTX_set_private_key_method.cc
  source/SSL_CTX_set_select_certificate_cb.cc
  source/SSL_CTX_set_select_certificate_cb.h
  source/SSL_CTX_set_strict_cipher_list.cc
  source/SSL_CTX_set_tlsext_servername_callback.cc
  source/SSL_CTX_set_tlsext_status_cb.c
  source/SSL_CTX_set_tlsext_ticket_key_cb.cc
  source/SSL_CTX_set_tlsext_ticket_keys.cc
  source/SSL_CTX_set_verify_algorithm_prefs.cc
  source/SSL_CTX_set_verify_depth.cc
  source/SSL_CTX_set_keylog_callback.cc
  source/SSL_CTX_set_next_proto_select_cb.cc
  source/SSL_CTX_set_verify.cc
  source/SSL_CTX_use_certificate.cc
  source/SSL_CTX_use_PrivateKey.cc
  source/SSL_early_callback_ctx_extension_get.c
  source/SSL_enable_ocsp_stapling.cc
  source/SSL_error_description.cc
  source/SSL_get0_ocsp_response.c
  source/SSL_get0_peer_verify_algorithms.cc
  source/SSL_get_cipher_by_value.c
  source/SSL_get_client_CA_list.cc
  source/SSL_get_ciphers.cc
  source/SSL_get_curve_id.c
  source/SSL_get_curve_name.c
  source/SSL_get_ex_new_index.cc
  source/SSL_get_peer_cert_chain.cc
  source/SSL_get_peer_full_cert_chain.cc
  source/SSL_get_peer_signature_algorithm.c
  source/SSL_get_servername.cc
  source/SSL_get_signature_algorithm_digest.cc
  source/SSL_get_signature_algorithm_key_type.cc
  source/SSL_get_signature_algorithm_name.c
  source/SSL_is_signature_algorithm_rsa_pss.cc
  source/SSL_send_fatal_alert.cc
  source/SSL_SESSION_from_bytes.c
  source/SSL_SESSION_get_ticket_lifetime_hint.cc
  source/SSL_SESSION_get_version.cc
  source/SSL_SESSION_new.cc
  source/SSL_SESSION_should_be_single_use.cc
  source/SSL_SESSION_to_bytes.c
  source/SSL_set_cert_cb.cc
  source/SSL_set_chain_and_key.cc
  source/SSL_set_client_CA_list.cc
  source/SSL_set_ocsp_response.cc
  source/SSL_set_renegotiate_mode.cc
  source/SSL_set_info_callback.cc
  source/SSL_set_verify.cc
  source/stack.c
  source/TLS_VERSION_to_string.cc
  source/TLS_with_buffers_method.cc
  source/X509_EXTENSION_get_data.cc
  source/X509_sign.cc
  source/X509_STORE_CTX_get0_untrusted.cc
  source/X509_STORE_CTX_init.cc
  source/X509_STORE_CTX_get0_chain.cc
  source/X509_STORE_CTX_set0_crls.cc
  source/X509_STORE_CTX_set0_trusted_stack.cc
  source/X509_STORE_CTX_set_verify_cb.cc
  source/X509_verify_cert_error_string.cc
  source/X509_VERIFY_PARAM_set_time_posix.cc
)

target_add_bssl_include(bssl-compat
  include/openssl/aead.h
  include/openssl/aes.h
  include/openssl/arm_arch.h
  include/openssl/asn1.h
  include/openssl/asn1_mac.h
  include/openssl/asn1t.h
  include/openssl/base64.h
  include/openssl/base.h
  include/openssl/bio.h
  include/openssl/blake2.h
  include/openssl/blowfish.h
  include/openssl/bn.h
  include/openssl/buffer.h
  include/openssl/buf.h
  include/openssl/bytestring.h
  include/openssl/cast.h
  include/openssl/chacha.h
  include/openssl/cipher.h
  include/openssl/cmac.h
  include/openssl/conf.h
  include/openssl/cpu.h
  include/openssl/crypto.h
  include/openssl/curve25519.h
  include/openssl/des.h
  include/openssl/dh.h
  include/openssl/digest.h
  include/openssl/dsa.h
  include/openssl/dtls1.h
  include/openssl/ecdh.h
  include/openssl/ecdsa.h
  include/openssl/ec.h
  include/openssl/ec_key.h
  include/openssl/engine.h
  include/openssl/e_os2.h
  include/openssl/err.h
  include/openssl/evp_errors.h
  include/openssl/evp.h
  include/openssl/ex_data.h
  include/openssl/hkdf.h
  include/openssl/hmac.h
  include/openssl/hpke.h
  include/openssl/hrss.h
  include/openssl/is_boringssl.h
  include/openssl/kdf.h
  include/openssl/lhash.h
  include/openssl/md4.h
  include/openssl/md5.h
  include/openssl/mem.h
  include/openssl/nid.h
  include/openssl/objects.h
  include/openssl/obj.h
  include/openssl/obj_mac.h
  include/openssl/opensslconf.h
  include/openssl/opensslv.h
  include/openssl/ossl_typ.h
  include/openssl/pem.h
  include/openssl/pkcs12.h
  include/openssl/pkcs7.h
  include/openssl/pkcs8.h
  include/openssl/poly1305.h
  include/openssl/pool.h
  include/openssl/rand.h
  include/openssl/rc4.h
  include/openssl/ripemd.h
  include/openssl/rsa.h
  include/openssl/safestack.h
  include/openssl/service_indicator.h
  include/openssl/sha.h
  include/openssl/siphash.h
  include/openssl/span.h
  include/openssl/srtp.h
  include/openssl/ssl3.h
  include/openssl/ssl.h
  include/openssl/stack.h
  include/openssl/thread.h
  include/openssl/tls1.h
  include/openssl/trust_token.h
  include/openssl/type_check.h
  include/openssl/x509.h
  include/openssl/x509v3.h
  include/openssl/x509_vfy.h
)

# Case where simple mapping exists
target_add_bssl_function(bssl-compat
  ASN1_IA5STRING_free
  ASN1_IA5STRING_new
  ASN1_IA5STRING_new
  ASN1_IA5STRING_new
  ASN1_INTEGER_free
  ASN1_INTEGER_new
  ASN1_INTEGER_to_BN
  ASN1_INTEGER_to_BN
  ASN1_OBJECT_free
  ASN1_STRING_data
  ASN1_STRING_free
  ASN1_STRING_get0_data
  ASN1_STRING_length
  ASN1_STRING_set
  ASN1_STRING_to_UTF8
  ASN1_TIME_adj
  ASN1_TIME_diff
  ASN1_TIME_new
  ASN1_TIME_set
  BIO_clear_flags
  BIO_clear_retry_flags
  BIO_clear_flags
  BIO_ctrl
  BIO_ctrl_get_read_request
  BIO_ctrl_get_write_guarantee
  BIO_get_data
  BIO_get_init
  BIO_get_mem_ptr
  BIO_get_shutdown
  BIO_new_connect
  BIO_new_mem_buf
  BIO_puts
  BIO_read
  BIO_reset
  BIO_get_mem_data
  BIO_set_data
  BIO_set_init
  BIO_set_mem_eof_return
  BIO_set_retry_read
  BIO_set_retry_write
  BIO_set_shutdown
  BIO_should_read
  BIO_should_retry
  BIO_should_write
  BIO_shutdown_wr
  BIO_up_ref
  BIO_free_all
  BIO_write
  BN_add_word
  BN_add_word
  BN_add_word
  BN_dup
  BN_free
  BN_hex2bn
  BN_new
  BN_num_bits
  BN_set_word
  BN_ucmp
  CRYPTO_memcmp
  d2i_PKCS12_bio
  d2i_SSL_SESSION
  d2i_X509
  DTLS_method
  EC_GROUP_get_curve_name
  EC_GROUP_get_degree
  EC_GROUP_get0_order
  EC_KEY_new_by_curve_name
  EC_KEY_free
  EC_KEY_get0_group
  ECDSA_size
  ECDSA_SIG_free
  ECDSA_SIG_get0
  ECDSA_SIG_new
  ECDSA_SIG_set0
  ERR_clear_error
  ERR_print_errors
  ERR_print_errors_fp
  ERR_put_error
  EVP_aes_256_cbc
  EVP_aes_128_gcm
  EVP_aes_256_gcm
  EVP_CIPHER_CTX_free
  EVP_CIPHER_CTX_new
  EVP_CIPHER_CTX_ctrl
  EVP_CIPHER_block_size
  EVP_CIPHER_iv_length
  EVP_CIPHER_key_length
  EVP_DecryptFinal_ex
  EVP_DecryptInit_ex
  EVP_DecryptUpdate
  EVP_DigestFinal
  EVP_DigestFinal_ex
  EVP_DigestInit
  EVP_DigestInit_ex
  EVP_DigestSignInit
  EVP_DigestSignUpdate
  EVP_DigestUpdate
  EVP_DigestVerify
  EVP_DigestVerifyUpdate
  EVP_DigestVerifyInit
  EVP_EncryptFinal_ex
  EVP_EncryptInit_ex
  EVP_EncryptUpdate
  EVP_MD_CTX_copy_ex
  EVP_MD_CTX_create
  EVP_MD_CTX_free
  EVP_MD_CTX_new
  EVP_MD_CTX_destroy
  EVP_MD_size
  EVP_MD_type
  EVP_md4
  EVP_md5
  EVP_md5_sha1
  EVP_PKEY_assign_EC_KEY
  EVP_PKEY_assign_RSA
  EVP_PKEY_cmp
  EVP_PKEY_CTX_set_rsa_mgf1_md
  EVP_PKEY_CTX_set_rsa_padding
  EVP_PKEY_free
  EVP_PKEY_up_ref
  EVP_PKEY_get_raw_public_key
  EVP_PKEY_new
  EVP_PKEY_set1_RSA
  EVP_sha1
  EVP_sha224
  EVP_sha256
  EVP_sha384
  EVP_sha512
  GENERAL_NAME_set0_value
  HMAC
  HMAC_CTX_free
  HMAC_CTX_new
  HMAC_Final
  HMAC_Update
  i2d_SSL_SESSION
  MD5
  OBJ_txt2obj
  OPENSSL_free
  OPENSSL_malloc
  OPENSSL_memdup
  OPENSSL_realloc
  OPENSSL_init_ssl
  PEM_bytes_read_bio
  PKCS12_free
  RSA_bits
  RSA_check_key
  RSA_free
  RSA_get0_crt_params
  RSA_get0_factors
  RSA_get0_key
  RSA_new
  RSA_set0_crt_params
  RSA_set0_factors
  RSA_set0_key
  RSA_sign
  RSA_size
  RSA_verify
  SHA1
  SHA224
  SHA256
  SHA384
  SHA512
  SSL_accept
  SSL_accept
  SSL_alert_desc_string_long
  SSL_CIPHER_get_auth_nid
  SSL_CIPHER_get_cipher_nid
  SSL_CIPHER_get_digest_nid
  SSL_CIPHER_get_id
  SSL_CIPHER_get_name
  SSL_CIPHER_standard_name
  SSL_connect
  SSL_CTX_add_extra_chain_cert
  SSL_CTX_check_private_key
  SSL_CTX_set_tmp_ecdh
  SSL_get0_next_proto_negotiated
  SSL_CTX_free
  SSL_CTX_get_cert_store
  SSL_CTX_set_cert_store
  SSL_CTX_get_ex_data
  SSL_CTX_get_options
  SSL_CTX_get_verify_mode
  SSL_CTX_get0_certificate
  SSL_CTX_get0_param
  SSL_CTX_load_verify_locations
  SSL_CTX_new
  SSL_CTX_set_alpn_protos
  SSL_CTX_set_cipher_list
  SSL_CTX_set_ex_data
  SSL_CTX_set_max_proto_version
  SSL_CTX_set_min_proto_version
  SSL_CTX_set_options
  SSL_CTX_set_session_cache_mode
  SSL_CTX_set_session_id_context
  SSL_CTX_set_timeout
  SSL_CTX_set_tlsext_servername_arg
  SSL_CTX_set1_curves_list
  SSL_CTX_set1_sigalgs_list
  SSL_CTX_use_certificate_chain_file
  SSL_CTX_use_certificate_file
  SSL_CTX_use_PrivateKey_file
  SSL_do_handshake
  SSL_free
  SSL_get_certificate
  SSL_get_current_cipher
  SSL_get_error
  SSL_get_ex_data
  SSL_get_ex_data_X509_STORE_CTX_idx
  SSL_get_peer_certificate
  SSL_get_session
  SSL_get_SSL_CTX
  SSL_get_version
  SSL_get_wbio
  SSL_get_rbio
  SSL_get0_alpn_selected
  SSL_get1_session
  SSL_is_server
  SSL_is_init_finished
  SSL_new
  SSL_read
  SSL_select_next_proto
  SSL_SESSION_free
  SSL_SESSION_get_id
  SSL_SESSION_is_resumable
  SSL_session_reused
  SSL_SESSION_set_protocol_version
  SSL_SESSION_up_ref
  SSL_set_accept_state
  SSL_set_alpn_protos
  SSL_set_bio
  SSL_set_cipher_list
  SSL_set_connect_state
  SSL_set_ex_data
  SSL_set_fd
  SSL_set_quiet_shutdown
  SSL_set_session
  SSL_set_session_id_context
  SSL_set_SSL_CTX
  SSL_set_tlsext_host_name
  SSL_set0_rbio
  SSL_set0_rbio
  SSL_set0_wbio
  SSL_set0_wbio
  SSL_set1_curves_list
  SSL_state_string_long
  SSL_state_string
  SSL_shutdown
  SSL_version
  SSL_write
  TLS_client_method
  TLS_method
  TLS_server_method
  X509_add1_ext_i2d
  X509_alias_get0
  X509_cmp
  X509_CRL_cmp
  X509_CRL_dup
  X509_CRL_get_issuer
  X509_CRL_free
  X509_CRL_up_ref
  X509_digest
  X509_free
  X509_get_ext
  X509_get_ext_by_OBJ
  X509_get_ext_d2i
  X509_get_extension_flags
  X509_get_issuer_name
  X509_get_key_usage
  X509_get_pathlen
  X509_get_pubkey
  X509_get_serialNumber
  X509_get_subject_name
  X509_get_X509_PUBKEY
  X509_get0_notAfter
  X509_get0_notBefore
  X509_getm_notAfter
  X509_getm_notBefore
  X509_INFO_free
  X509_NAME_add_entry_by_txt
  X509_NAME_cmp
  X509_NAME_digest
  X509_NAME_dup
  X509_NAME_entry_count
  X509_NAME_ENTRY_get_data
  X509_NAME_ENTRY_set
  X509_NAME_free
  X509_NAME_get_entry
  X509_NAME_get_index_by_NID
  X509_NAME_new
  X509_NAME_oneline
  X509_NAME_print_ex
  X509_new
  X509_PUBKEY_get
  X509_set_pubkey
  X509_set_version
  X509_STORE_add_cert
  X509_STORE_add_crl
  X509_STORE_CTX_free
  X509_STORE_CTX_get_current_cert
  X509_STORE_CTX_get_error
  X509_STORE_CTX_get_error_depth
  X509_STORE_CTX_get_ex_data
  X509_STORE_CTX_get0_cert
  X509_STORE_CTX_get0_param
  X509_STORE_CTX_new
  X509_STORE_CTX_set_default
  X509_STORE_CTX_set_error
  X509_STORE_CTX_set_flags
  X509_STORE_free
  X509_STORE_get0_param
  X509_STORE_load_locations
  X509_STORE_new
  X509_STORE_up_ref
  X509_STORE_set_flags
  X509_STORE_set_get_crl
  X509_STORE_set_check_crl
  X509_STORE_set_verify_cb
  X509_up_ref
  X509_verify
  X509_verify_cert
  X509_VERIFY_PARAM_clear_flags
  X509_VERIFY_PARAM_get_flags
  X509_VERIFY_PARAM_set_flags
  X509_VERIFY_PARAM_set1
)

target_add_bssl_source(bssl-compat
  source/crypto/internal.h
  source/crypto/mem.c
  source/crypto/bytestring/cbs.c
  source/crypto/bytestring/cbb.c
  source/ssl/ssl_x509.cc
)
target_compile_definitions(bssl-compat PUBLIC ossl_OPENSSL_SUPPRESS_DEPRECATED)
target_include_directories(bssl-compat PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_include_directories(bssl-compat PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/include)
target_include_directories(bssl-compat PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/source)
target_link_libraries(bssl-compat INTERFACE ${CMAKE_DL_LIBS})

################################################################################
# Intallation
################################################################################

set(INSTALL_GTEST OFF)
install(TARGETS bssl-compat ARCHIVE DESTINATION lib)
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include DESTINATION . FILES_MATCHING PATTERN "*.h")
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/ossl DESTINATION include FILES_MATCHING PATTERN "*.h")
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/openssl DESTINATION include FILES_MATCHING PATTERN "*.h")
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/include/ossl.h DESTINATION include)

################################################################################
# Unit Tests
################################################################################

FetchContent_Declare(googletest URL ${CMAKE_SOURCE_DIR}/vendor/googletest-5376968f6948923e2411081fd9372e71a59d8e77.zip)
FetchContent_MakeAvailable(googletest)
enable_testing()

set(utests-bssl-source-list
  # Tests copied/patched from BoringSSL
  source/crypto/bio/bio_test.cc
  source/crypto/digest_extra/digest_test.cc
  source/crypto/err/err_test.cc
  source/crypto/hmac_extra/hmac_test.cc
  source/crypto/pkcs8/pkcs12_test.cc
  source/crypto/rand_extra/rand_test.cc
  source/crypto/rsa_extra/rsa_test.cc
  source/crypto/stack/stack_test.cc
  source/crypto/test/file_test_gtest.cc
  source/crypto/test/file_test.cc
  source/crypto/test/file_test.h
  source/crypto/internal.h
  source/crypto/test/test_util.cc
  source/crypto/test/test_util.h
  source/crypto/x509/x509_test.cc
  source/crypto/x509v3/internal.h
  source/ssl/ssl_c_test.c
  source/ssl/ssl_test.cc
)

set(utests-source-list
  # Our hand written bssl-compat tests
  source/test/test_asn1.cc
  source/test/test_bio.cc
  source/test/test_bn.cc
  source/test/test_cipher.cc
  source/test/test_crypto.cc
  source/test/test_ec_key.cc
  source/test/test_err.cc
  source/test/test_evp.cc
  source/test/test_hmac.cc
  source/test/test_misc.cc
  source/test/test_rsa.cc
  source/test/test_ssl.cc
  source/test/test_stack.cc
  source/test/test_x509.cc
  source/test/test_x509v3.cc
  source/test/test_pem.cc
  source/test/test_sha256.cc
  # Test data copied from BoringSSL
  source/crypto/test/crypto_test_data.cc
)

################################################################################
# Unit Tests built on bssl-compat
################################################################################
add_executable(utests-bssl-compat ${utests-source-list})
target_add_bssl_source(utests-bssl-compat ${utests-bssl-source-list})
set_source_files_properties(source/extra/err_extra.c PROPERTIES COMPILE_FLAGS -Wno-deprecated-declarations)
# Add env variable SANITIZE_OPTIONS for optional sanitizers
target_link_options(utests-bssl-compat PRIVATE "$ENV{SANITIZE_OPTIONS}" )
target_link_libraries(utests-bssl-compat PRIVATE GTest::gtest_main bssl-compat)
set_target_properties(utests-bssl-compat PROPERTIES BUILD_RPATH "${OPENSSL_LIBRARY_DIR}")
gtest_discover_tests(utests-bssl-compat)

################################################################################
# Unit Tests built on BoringSSL
################################################################################
if(BUILD_BORINGSSL)
  add_executable(utests-boring ${utests-source-list})
  target_add_bssl_source(utests-boring ${utests-bssl-source-list})
  target_include_directories(utests-boring PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/source)
  # Add env variable SANITIZE_OPTIONS for optional sanitizers
  target_link_options(utests-boring PRIVATE "$ENV{SANITIZE_OPTIONS}" )
  target_link_libraries(utests-boring PRIVATE BoringSSL::SSL BoringSSL::Crypto)
  target_link_libraries(utests-boring PRIVATE GTest::gtest_main)
  gtest_discover_tests(utests-boring)
endif(BUILD_BORINGSSL)
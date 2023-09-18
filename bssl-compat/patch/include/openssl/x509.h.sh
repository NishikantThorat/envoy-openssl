#!/bin/bash

set -euo pipefail

uncomment.sh "$1" --comment -h \
  --uncomment-regex 'DEFINE_STACK_OF(X509)' \
  --uncomment-func-decl X509_up_ref \
  --uncomment-func-decl X509_free \
  --uncomment-func-decl i2d_X509 \
  --uncomment-macro-redef 'X509_VERSION_[123]' \
  --uncomment-func-decl X509_get0_notBefore \
  --uncomment-func-decl X509_get0_notAfter \
  --uncomment-func-decl X509_get_issuer_name \
  --uncomment-func-decl X509_get_subject_name \
  --uncomment-func-decl X509_get_X509_PUBKEY \
  --uncomment-func-decl X509_get_pubkey \
  --uncomment-func-decl X509_get_ext_by_OBJ \
  --uncomment-func-decl X509_get_ext \
  --uncomment-func-decl X509_new \
  --uncomment-func-decl X509_set_version \
  --uncomment-func-decl X509_getm_notBefore \
  --uncomment-func-decl X509_getm_notAfter \
  --uncomment-func-decl X509_set_pubkey \
  --uncomment-func-decl X509_sign \
  --uncomment-func-decl X509_alias_get0 \
  --uncomment-regex 'DEFINE_STACK_OF(X509_CRL)' \
  --uncomment-func-decl X509_CRL_up_ref \
  --uncomment-func-decl X509_CRL_free \
  --uncomment-regex 'DEFINE_STACK_OF(X509_NAME_ENTRY)' \
  --uncomment-regex 'DEFINE_STACK_OF(X509_NAME)' \
  --uncomment-func-decl X509_NAME_new \
  --uncomment-func-decl X509_NAME_free \
  --uncomment-func-decl X509_NAME_dup \
  --uncomment-func-decl X509_NAME_entry_count \
  --uncomment-func-decl X509_NAME_get_index_by_NID \
  --uncomment-func-decl X509_NAME_get_entry \
  --uncomment-func-decl X509_NAME_add_entry_by_txt \
  --uncomment-func-decl X509_NAME_ENTRY_set \
  --uncomment-func-decl X509_EXTENSION_get_data \
  --uncomment-func-decl X509_digest \
  --uncomment-func-decl X509_NAME_digest \
  --uncomment-func-decl X509_STORE_CTX_get_ex_data \
  --uncomment-func-decl X509_get_serialNumber \
  --uncomment-macro-redef 'XN_FLAG_[[:alnum:]_]*' \
  --uncomment-regex 'DEFINE_STACK_OF(X509_INFO)' \
  --uncomment-func-decl X509_get_pathlen \
  --uncomment-func-decl X509_verify_cert_error_string \
  --uncomment-func-decl X509_verify \
  --uncomment-func-decl X509_PUBKEY_get \
  --uncomment-func-decl X509_INFO_free \
  --uncomment-func-decl X509_cmp \
  --uncomment-func-decl X509_NAME_cmp \
  --uncomment-func-decl X509_CRL_cmp \
  --uncomment-func-decl X509_NAME_print_ex \
  --uncomment-func-decl X509_NAME_ENTRY_get_data \
  --uncomment-func-decl X509_get_ext_d2i \
  --uncomment-func-decl X509_add1_ext_i2d \
  --uncomment-func-decl X509_verify_cert \
  --uncomment-typedef X509_STORE_CTX_verify_cb \
  --uncomment-macro-redef 'X509_V_[[:alnum:]_]*' \
  --uncomment-func-decl X509_STORE_new \
  --uncomment-func-decl X509_STORE_free \
  --uncomment-func-decl X509_STORE_get0_param \
  --uncomment-func-decl X509_STORE_set_flags \
  --uncomment-func-decl X509_STORE_set_verify_cb \
  --uncomment-func-decl X509_STORE_load_locations \
  --uncomment-func-decl X509_STORE_up_ref \
  --uncomment-func-decl X509_STORE_CTX_new \
  --uncomment-func-decl X509_STORE_CTX_free \
  --uncomment-func-decl X509_STORE_CTX_init \
  --uncomment-func-decl X509_STORE_CTX_set0_trusted_stack \
  --uncomment-func-decl X509_STORE_add_cert \
  --uncomment-func-decl X509_STORE_add_crl \
  --uncomment-func-decl X509_STORE_CTX_get_error \
  --uncomment-func-decl X509_STORE_CTX_set_error \
  --uncomment-func-decl X509_STORE_CTX_get_error_depth \
  --uncomment-func-decl X509_STORE_CTX_get0_untrusted \
  --uncomment-func-decl X509_STORE_CTX_set0_crls \
  --uncomment-func-decl X509_STORE_CTX_set_verify_cb \
  --uncomment-func-decl X509_STORE_CTX_get0_param \
  --uncomment-func-decl X509_STORE_CTX_set_default \
  --uncomment-func-decl X509_VERIFY_PARAM_set1 \
  --uncomment-func-decl X509_VERIFY_PARAM_set_flags \
  --uncomment-func-decl X509_VERIFY_PARAM_clear_flags \
  --uncomment-func-decl X509_VERIFY_PARAM_set_time_posix \
  --uncomment-regex 'BORINGSSL_MAKE_DELETER(X509,' \
  --uncomment-regex 'BORINGSSL_MAKE_UP_REF(X509,' \
  --uncomment-regex 'BORINGSSL_MAKE_DELETER(X509_CRL,' \
  --uncomment-regex 'BORINGSSL_MAKE_UP_REF(X509_CRL,' \
  --uncomment-regex 'BORINGSSL_MAKE_DELETER(X509_INFO,' \
  --uncomment-regex 'BORINGSSL_MAKE_DELETER(X509_NAME,' \
  --uncomment-regex 'BORINGSSL_MAKE_DELETER(X509_STORE,' \
  --uncomment-regex 'BORINGSSL_MAKE_DELETER(X509_STORE_CTX,' \
  --uncomment-macro-redef 'X509_R_[[:alnum:]_]*' \

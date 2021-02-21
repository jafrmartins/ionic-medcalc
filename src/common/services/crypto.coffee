crypto = require 'crypto-browserify'

class CryptoService

  cipher: (text, password, algorithm='aes256') ->
    cipher = crypto.createCipher algorithm, password
    crypted = cipher.update text, 'utf8', 'hex'
    crypted += cipher.final 'hex'
    crypted

  decipher: (text, password, algorithm='aes256') -> 
    decipher = crypto.createDecipher algorithm, password
    decrypted = decipher.update text, 'hex', 'utf8'
    decrypted += decipher.final 'utf8'
    decrypted

module.exports = CryptoService
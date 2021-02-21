DEV = "http://192.168.1.69:3000"
PROD = "https://rugged-everglades-42324.herokuapp.com"
DOMAIN = PROD

module.exports =
  "app":
    copyright: "NetMedicis #{new Date().getFullYear()} ®"
    logo: "img/logo.png"
  "auth":
    endpoint: "#{DOMAIN}/auth" # "/auth"
  "netmedicis": 
    endpoint: "#{DOMAIN}/netmedicis" # "/netmedicis"
  "api":
    endpoint: "offline/api/v1"
  "offline":
    endpoint: "offline/methods"
  "i18n":
    langs: [ 'pt', 'en' ]
    locales: {
      'pt_PT': 'pt',
      'pt_BR': 'pt',
      'en_US': 'en',
      'en_UK': 'en' 
    }

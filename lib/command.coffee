path = require('path')
fs = require('fs')
parser = require('L7')
Faker = require('Faker')
_s = require('underscore.string')

num = (x, places) ->
  x = Math.floor(Math.random() * x) + 1
  if places
    _s.lpad(x, places, '0')
  else
    x

randomDate = ->
  "#{1900 + num(new Date().getYear())}#{num(12, 2)}#{num(28, 2)}"

module.exports =
  run: ->
    [ engine, executable, input ] = process.argv

    fs.readFile(path.join(process.cwd, input), 'utf8', (err, content) ->
      if err
        console.log(err)
      else
        messages = content.split(/(\r\n){2,}/)

        deindentified = _.map(messages, (message) ->
          message = message.trim()
          return unless message

          replace = (query, replacement) ->
            search = parsed.query(query)?.replace(/([()^])/g, '\\$1')
            if search
              message = message.replace(///\|#{search}(\|)?///g, "|#{replacement.toUpperCase()}$1")

          parsed = parser.parse(message)
          replace('PID|5', "#{Faker.Name.lastName()}^#{Faker.Name.firstName()}")
          replace('NK1|2', "#{Faker.Name.lastName()}^#{Faker.Name.firstName()}")
          replace('NK1|4',  "#{Faker.Address.streetAddress()}^^#{Faker.Address.city()}^^#{Faker.Address.zipCode()}")
          replace('PID|11', "#{Faker.Address.streetAddress()}^^#{Faker.Address.city()}^^#{Faker.Address.zipCode()}")
          replace('PID|7', randomDate())
          console.log(message)
          console.log('\r\n')
        )
    )

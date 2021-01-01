const { environment } = require('@rails/webpacker')

const styleLoader = {
  test: /\.scss$/,
  use: [
    {
      loader: 'style-loader', // inject CSS to page
    }, {
      loader: 'css-loader', // translates CSS into CommonJS modules
    }, {
      loader: 'sass-loader',
    }
  ]
}

const woffFontLoader = {
  test: /\.(woff|woff2)(\?v=\d+\.\d+\.\d+)?$/,
  use: [
    { loader: 'url-loader?limit=10000&mimetype=application/font-woff' }
  ]
}

const ttfFontLoader = {
  test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
  use: [
    { loader: 'url-loader?limit=10000&mimetype=application/octet-stream' }
  ]
}

const eotFontLoader = {
  test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
  use: [
    { loader: 'file-loader' }
  ]
}

environment.loaders.append('woffFont', woffFontLoader)
environment.loaders.append('ttfFont', ttfFontLoader)
environment.loaders.append('eotFont', eotFontLoader)
environment.loaders.prepend('style', styleLoader)

console.log(environment.loaders)
module.exports = environment

const { environment } = require('@rails/webpacker')
const customConfig = {
  resolve: {
    extensions: ['.css']
  }
}

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

// environment.config.merge(customConfig)
// environment.loaders.append('style', styleLoader)
module.exports = environment

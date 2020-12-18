const { environment } = require('@rails/webpacker');
const webpack = require('webpack');

// environment.config.merge({
//   module: {
//     rules: [
//       {
//         test: /\.css$/i,
//         use: [
//           { loader: 'style-loader' },
//           { loader: 'css-loader' },
//         ]
//       },
//       {
//         test: /\.s[ac]ss$/i,
//         use: [
//           { loader: 'style-loader' },
//           { loader: 'css-loader' },
//           { loader: 'sass-loader' },
//         ]
//       },
//     ]
//   }
// });

module.exports = environment;

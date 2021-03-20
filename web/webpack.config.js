const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MonacoWebpackPlugin = require('monaco-editor-webpack-plugin');
const path = require('path');

module.exports = {
    entry: './src/index.js',
    devtool: 'source-map',
    output: {
        path: path.resolve(__dirname, '../Sources/SwiftyMonaco/Resources'),
        filename: 'app.js'
    },
    module: {
        rules: [
            {
                test: /\.css$/,
                use: [
                    'style-loader',
                    'css-loader'
                ]
            },
            {
                test: /\.ttf$/,
                use: ['file-loader']
            }
        ]
    },
    plugins: [
        new CleanWebpackPlugin(),
        new MonacoWebpackPlugin(),
        new HtmlWebpackPlugin({
            title: 'Text Editor'
        })
    ]
};

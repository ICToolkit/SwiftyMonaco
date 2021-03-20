import * as monaco from 'monaco-editor';
import './styles.css';

(function() {
    class MonacoEditorHost {
        constructor() {
            this.contextKeys = {};
        }

        create(options) {
            const hostElement = document.createElement('div');
            hostElement.id = 'editor';
            document.body.appendChild(hostElement);

            this.editor = monaco.editor.create(hostElement, options);
            this.editor.focus();
            this.editor.onDidChangeModelContent((event) => {
                var text = this.editor.getValue();
                window.webkit.messageHandlers.updateText.postMessage(btoa(text));
            });
        }

        addAction(fn) {
            fn(monaco, this.editor);
        }

        addCommand(fn) {
            fn(monaco, this.editor);
        }

        createContextKey(key, defaultValue) {
            const contextKey = this.editor.createContextKey(key, defaultValue);
            this.contextKeys[key] = contextKey;
        }

        focus() {
            this.editor.focus();
        }

        getContextKey(key) {
            return this.contextKeys[key].get();
        }

        resetContextKey(key) {
            this.contextKeys[key].reset();
        }

        setContextKey(key, value) {
            this.contextKeys[key].set(value);
        }

        setText(text) {
            this.editor.setValue(text);
        }

        updateOptions(options) {
            this.editor.updateOptions(options);
        }
    }

    function main() {
        window.editor = new MonacoEditorHost();
    }

    document.addEventListener('DOMContentLoaded', main);
})();

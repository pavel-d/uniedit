#### Unieditor - Realtime collaborative web-editor

Example: http://unieditor.herokuapp.com/

1. Open http://unieditor.herokuapp.com/, you'll be redirected to newly created document -> http://unieditor.herokuapp.com/:id
2. Share the link to someone
3. Start writing, text will be updated across all browsers via websockets in realtime

##### Features:

- Text editing
- Syntax highlighting
- Based on Ace Editor

##### Technologies:
- Node.js (CoffeeScript)
- Socket.io
- MySQL

##### How to setup

```
git clone git@github.com:pavel-d/uniedit.git
cd uniedit
npm install
npm start
```

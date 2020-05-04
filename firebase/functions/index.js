const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const firestore = admin.firestore();

// // https://firebase.google.com/docs/functions/write-firebase-functions

exports.authRedirectHandler = functions.https.onRequest(
    async (request, response) => {
        try{
            const state = request.query.state;
            if(!state) {
                // noinspection ExceptionCaughtLocallyJS
                throw new Error('Missing state parameter');
            }

            const code = request.query.code;
            if(!code) {
                // noinspection ExceptionCaughtLocallyJS
                throw new Error('Missing code parameter');
            }

            const doc = await firestore.doc(`redirects/${state}`).get();

            if(!doc.exists) {
                // noinspection ExceptionCaughtLocallyJS
                throw new Error('Invalid id');
            }

            await doc.ref.update({ 'state': 'authorized', 'code': code });

            response
                .contentType('text/html')
                .status(200)
                .send('<html lang="en"><body><script>window.close();</script></body></html>');
        }
        catch(error) {
            response
                .contentType('text/html')
                .status(500)
                .send(`<html lang="en"><body><h2>${error}</h2></body></html>`);
        }
    }
);

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript
export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

// Sample callable function with authenticated user context
export const getUserDetails = functions.https.onCall((data, context) => {
  // Message text passed from the client.
  const text = data.text;
  // Authentication / user information is automatically added to the request.
  const uid = context.auth?.uid;
  const name = context.auth?.token.name || null;
  const picture = context.auth?.token.picture || null;
  const email = context.auth?.token.email || null;

  console.log("getUserDetails", {text, uid, name, picture, email});

  return {
    text: text,
    uid: uid,
    name: name,
    picture: picture,
    email: email,
  };
});

// Sample callable function with authenticated user context and firestore
export const getUserData = functions.https.onCall((data, context) => {
  // Message text passed from the client.
  const text = data.text;
  // Authentication / user information is automatically added to the request.
  const uid = context.auth?.uid;
  const name = context.auth?.token.name || null;
  const picture = context.auth?.token.picture || null;
  const email = context.auth?.token.email || null;

  // Check if uid is null
  if (!uid) {
    console.log("getUserData", "uid is null");
    return null;
  }

  console.log("getUserData", {text, uid, name, picture, email});

  // Get user data from firestore
  const db = admin.firestore();
  const userRef = db.collection("users").doc(uid);

  return userRef.get().then((doc) => {
    if (doc.exists) {
      console.log("Document data:", doc.data());
      return doc.data();
    } else {
      // doc.data() will be undefined in this case
      console.log("No such document!");
      return null;
    }
  }).catch((error) => {
    console.log("Error getting document:", error);
    return null;
  });
});

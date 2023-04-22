import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

// Sample callable function with authenticated user context
export const getUserDetails = functions.https.onCall((data, context) => {
  // Message text passed from the client.
  const text = data.text;
  // Authentication / user information is automatically added to the request.
  const uid = context.auth?.uid;
  const name = context.auth?.token.name || null;
  const picture = context.auth?.token.picture || null;
  const email = context.auth?.token.email || null;
  functions.logger.info("getUserDetails", {text, uid, name, picture, email});
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
  const uid = context.auth?.uid;
  // Check if uid is null
  if (!uid) {
    functions.logger.info("getUserData", "uid is null");
    return null;
  }
  // Get user data from firestore
  const db = admin.firestore();
  const userRef = db.collection("users").doc(uid);
  return userRef.get().then((doc) => {
    if (doc.exists) {
      functions.logger.info("Document data:", doc.data());
      return doc.data();
    } else {
      // doc.data() will be undefined in this case
      functions.logger.info("No such document!");
      return null;
    }
  }).catch((error) => {
    functions.logger.info("Error getting document:", error);
    return null;
  });
});

// Create the user document on signup
export const createUserDocumentOnSignUp = functions.auth.user()
    .onCreate((user) => {
      const db = admin.firestore();
      const userRef = db.collection("users").doc(user.uid);
      return userRef.set({
        uid: user.uid,
        // Timestamps won't be available in emulator
        createdAt: admin.firestore.FieldValue?.serverTimestamp() || null,
        updatedAt: admin.firestore.FieldValue?.serverTimestamp() || null,
        // eslint-disable-next-line max-len
        message: "This Firestore document was automatically created on user signup by Cloud Functions!",
      });
    });

// Delete the user document on delete
export const deleteUserDocumentOnDelete = functions.auth.user()
    .onDelete((user) => {
      const db = admin.firestore();
      const userRef = db.collection("users").doc(user.uid);
      return userRef.delete();
    });

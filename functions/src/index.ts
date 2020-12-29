import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

admin.initializeApp();

const fcm = admin.messaging();

export const sendNotification = functions.firestore
    .document('announcements/{announcementID}')
    .onCreate(async (snapshot) => {
        const announcement = snapshot.data();
        const condition = "!('industry-tech' in topics)";
        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: 'New Announcement!',
                body: announcement.title,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                icon:
                    'https://drive.google.com/uc?export=view&id=1uJN7SufcHG4eHscBSbfdowyVlychy407',
            },
        };

        return fcm.sendToCondition(condition, payload);
    });

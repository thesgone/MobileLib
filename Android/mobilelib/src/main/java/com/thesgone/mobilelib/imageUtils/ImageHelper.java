package com.thesgone.mobilelib.imageUtils;

import android.app.Activity;
import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;
import android.media.ExifInterface;
import android.net.Uri;
import android.provider.MediaStore;

import java.io.FileNotFoundException;
import java.io.IOException;

/**
 * Created by stefanogiovannitti on 25/11/14.
 */
public class ImageHelper {

    private static String getRealPathFromURI(Uri contentURI, Activity activity) {
        Cursor cursor = activity.getContentResolver()
                .query(contentURI, null, null, null, null);
        if (cursor == null) {
            return contentURI.getPath();
        } else {
            cursor.moveToFirst();
            int idx = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA);
            return cursor.getString(idx);
        }
    }

    public static Bitmap getImageFromBundle(Context context, int id){
        return BitmapFactory.decodeResource(context.getResources(), id);

    }

    public static int getOrientation(Uri photoUri, Activity activity) {


        ExifInterface exif = null;
        try {
            String path = getRealPathFromURI(photoUri, activity);
            exif = new ExifInterface(path);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
        int orientation = 0;
        if (exif != null)
            orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, -1);

        return orientation;
    }

    public static Bitmap rotateBitmap(Bitmap bitmap, int orientation) {

        Matrix matrix = new Matrix();
        switch (orientation) {
            case ExifInterface.ORIENTATION_NORMAL:
                return bitmap;
            case ExifInterface.ORIENTATION_FLIP_HORIZONTAL:
                matrix.setScale(-1, 1);
                break;
            case ExifInterface.ORIENTATION_ROTATE_180:
                matrix.setRotate(180);
                break;
            case ExifInterface.ORIENTATION_FLIP_VERTICAL:
                matrix.setRotate(180);
                matrix.postScale(-1, 1);
                break;
            case ExifInterface.ORIENTATION_TRANSPOSE:
                matrix.setRotate(90);
                matrix.postScale(-1, 1);
                break;
            case ExifInterface.ORIENTATION_ROTATE_90:
                matrix.setRotate(90);
                break;
            case ExifInterface.ORIENTATION_TRANSVERSE:
                matrix.setRotate(-90);
                matrix.postScale(-1, 1);
                break;
            case ExifInterface.ORIENTATION_ROTATE_270:
                matrix.setRotate(-90);
                break;
            default:
                return bitmap;
        }
        try {
            Bitmap bmRotated = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
            bitmap.recycle();
            return bmRotated;
        }
        catch (OutOfMemoryError e) {
            e.printStackTrace();
            return null;
        }
    }

    public static Bitmap decodeUriAndRotate(Uri photoUri, Activity activity, int requiredSize) throws FileNotFoundException {

        // Decode image size
        BitmapFactory.Options o = new BitmapFactory.Options();
        o.inJustDecodeBounds = true;
        BitmapFactory.decodeStream(activity.getContentResolver().openInputStream(photoUri), null, o);

        int rotatedWidth, rotatedHeight;
        int orientation = getOrientation(photoUri, activity);


        if (orientation == ExifInterface.ORIENTATION_ROTATE_90 || orientation == ExifInterface.ORIENTATION_ROTATE_180) {
            rotatedWidth = o.outHeight;
            rotatedHeight = o.outWidth;
        } else {
            rotatedWidth = o.outWidth;
            rotatedHeight = o.outHeight;
        }

        // Find the correct scale value. It should be the power of 2.
        int width_tmp = rotatedWidth, height_tmp = rotatedHeight;
        int scale = 1;
        while (true) {
            if (width_tmp / 2 < requiredSize
                    || height_tmp / 2 < requiredSize) {
                break;
            }
            width_tmp /= 2;
            height_tmp /= 2;
            scale *= 2;
        }

        // Decode with inSampleSize
        BitmapFactory.Options o2 = new BitmapFactory.Options();
        o2.inSampleSize = scale;
        Bitmap image =  BitmapFactory.decodeStream(activity.getContentResolver().openInputStream(photoUri), null, o2);

        if (orientation != ExifInterface.ORIENTATION_NORMAL) {
            image = rotateBitmap(image, orientation);
        }

        return image;


    }

    public static Bitmap scaleImage(Bitmap input, int requiredSize){
        int width_tmp = input.getWidth();
        int height_tmp = input.getHeight();

        while (true) {
            if (width_tmp / 2 < requiredSize
                    || height_tmp / 2 < requiredSize) {
                break;
            }
            width_tmp /= 2;
            height_tmp /= 2;
        }

        return Bitmap.createScaledBitmap(input, width_tmp, height_tmp, false);
    }

    public static Bitmap getRoundedCornerBitmap(Bitmap bitmap, int pixels) {
        Bitmap output = Bitmap.createBitmap(bitmap.getWidth(), bitmap
                .getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(output);

        final int color = 0xff424242;
        final Paint paint = new Paint();
        final Rect rect = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());
        final RectF rectF = new RectF(rect);
        final float roundPx = pixels;

        paint.setAntiAlias(true);
        canvas.drawARGB(0, 0, 0, 0);
        paint.setColor(color);
        canvas.drawRoundRect(rectF, roundPx, roundPx, paint);

        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));
        canvas.drawBitmap(bitmap, rect, rect, paint);

        return output;
    }

    static public Bitmap convertToBitmap(Drawable drawable, int widthPixels, int heightPixels) {
        Bitmap mutableBitmap = Bitmap.createBitmap(widthPixels, heightPixels, Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(mutableBitmap);
        drawable.setBounds(0, 0, widthPixels, heightPixels);
        drawable.draw(canvas);

        return mutableBitmap;
    }



}

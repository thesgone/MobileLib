package com.thesgone.mobilelib.push;

import android.content.Context;

import com.parse.FindCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.thesgone.mobilelib.interfece.MLCompletion;
import com.thesgone.mobilelib.popUp.MLPopUp;

import java.util.List;

/**
 * Created by stefanogiovannitti on 23/11/14.
 */
public abstract class SafeFindCallBack< T extends ParseObject> extends FindCallback< T >{

    public Context context_;
    MLCompletion errorCompletion_;
    public String title_;

    public SafeFindCallBack(Context context){
        context_ = context;
    }

    public void setErrorCompletion(MLCompletion errorCompletion){
        errorCompletion_ = errorCompletion;
    }

    public abstract void doneImpl(List< T > objects);

    @Override
    public void done(List< T > objects, ParseException e) {
        if (e == null) {
            try {
                doneImpl(objects);
            }catch (Exception e1){
                if(errorCompletion_ != null)
                    errorCompletion_.performCompletion();
                if(context_!=null)
                    MLPopUp.display(title_, e1.getMessage(), context_);
            }
        }else{
            if(errorCompletion_ != null)
                errorCompletion_.performCompletion();
            if(context_!=null)
                MLPopUp.display(title_, e.getMessage(), context_);
        }
    }
}

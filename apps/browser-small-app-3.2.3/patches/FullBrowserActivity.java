package com.sonymobile.smallbrowser;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.ContentValues;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.ColorStateList;
import android.content.res.Configuration;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.webkit.GeolocationPermissions;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;
import java.lang.reflect.Method;

/** Standalone host for the original Sony Small Browser interface. */
public class FullBrowserActivity extends Activity implements View.OnClickListener {
    private static final String DEFAULT_HOME = "https://www.google.com/";
    private static final Uri BOOKMARKS =
            Uri.parse("content://com.sonymobile.smallbrowser/bookmarks");

    private EditText addressBar;
    private WebView webView;
    private ImageButton backButton;
    private ImageButton forwardButton;
    private ImageButton reloadButton;
    private ImageButton bookmarkButton;
    private PopupWindow menu;
    private CheckBox desktopCheckBox;
    private String mobileUserAgent;
    private boolean loading;

    @Override
    protected void onCreate(Bundle state) {
        super.onCreate(state);
        initializeSonyConfiguration();
        setContentView(res("layout", "plusone_main_sys"));

        hide("mini_move");
        hide("mini_close");
        hide("menu_pos");
        hide("lock");

        addressBar = (EditText) view("url");
        webView = (WebView) view("web");
        backButton = (ImageButton) view("back");
        forwardButton = (ImageButton) view("forward");
        reloadButton = (ImageButton) view("reload");
        bookmarkButton = (ImageButton) view("star");

        bind("back");
        bind("forward");
        bind("reload");
        bind("star");
        bind("call_browser");
        bind("mini_menu");
        applyResponsiveToolbar();

        addressBar.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView view, int actionId, KeyEvent event) {
                boolean enter = event != null && event.getKeyCode() == KeyEvent.KEYCODE_ENTER
                        && event.getAction() == KeyEvent.ACTION_UP;
                if (actionId == EditorInfo.IME_ACTION_GO || enter) {
                    loadAddress(view.getText().toString());
                    return true;
                }
                return false;
            }
        });

        configureWebView();
        if (isDesktopMode()) {
            webView.getSettings().setUserAgentString(desktopUserAgent());
        }
        createMenu();

        String firstUrl = DEFAULT_HOME;
        if (state != null && state.getString("url") != null) {
            firstUrl = state.getString("url");
        } else if (getIntent() != null && getIntent().getData() != null) {
            firstUrl = getIntent().getData().toString();
        }
        loadAddress(firstUrl);
    }

    private void configureWebView() {
        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setLoadWithOverviewMode(true);
        settings.setUseWideViewPort(true);
        settings.setSupportZoom(true);
        settings.setBuiltInZoomControls(true);
        settings.setDisplayZoomControls(false);
        mobileUserAgent = settings.getUserAgentString();

        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                if (url == null) {
                    return false;
                }
                if (url.startsWith("http://") || url.startsWith("https://")
                        || url.startsWith("file://") || url.startsWith("content://")) {
                    return false;
                }
                return openExternal(url);
            }

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                loading = true;
                addressBar.setText(url);
                reloadButton.setImageResource(res("drawable", "mini_button_stop"));
                updateNavigation();
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                loading = false;
                addressBar.setText(url);
                reloadButton.setImageResource(res("drawable", "mini_button_reload"));
                updateNavigation();
            }
        });
        webView.setWebChromeClient(new WebChromeClient() {
            @Override
            public void onReceivedIcon(WebView view, Bitmap icon) {
                ImageView favicon = (ImageView) FullBrowserActivity.this.view("favicon");
                if (favicon != null) {
                    favicon.setImageBitmap(icon);
                }
            }

            @Override
            public void onGeolocationPermissionsShowPrompt(
                    final String origin, final GeolocationPermissions.Callback callback) {
                new AlertDialog.Builder(FullBrowserActivity.this)
                        .setTitle(text("geolocation_permissions_prompt_title", "位置資訊"))
                        .setMessage(origin)
                        .setPositiveButton(text("geolocation_permissions_prompt_share", "允許"),
                                new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {
                                        callback.invoke(origin, true, false);
                                    }
                                })
                        .setNegativeButton(text("geolocation_permissions_prompt_dont_share", "拒絕"),
                                new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {
                                        callback.invoke(origin, false, false);
                                    }
                                })
                        .show();
            }
        });
        webView.setDownloadListener(new android.webkit.DownloadListener() {
            @Override
            public void onDownloadStart(String url, String userAgent, String contentDisposition,
                    String mimetype, long length) {
                openExternal(url);
            }
        });
    }

    private void createMenu() {
        View content = LayoutInflater.from(this).inflate(res("layout", "plusone_menu"), null);
        hideIn(content, "mini_window_fit_menu_id");
        hideIn(content, "mini_window_unfit_menu_id");

        bindIn(content, "forward");
        bindIn(content, "reload");
        bindIn(content, "star");
        bindIn(content, "mini_openathers_menu_id");
        bindIn(content, "mini_home_menu_id");
        bindIn(content, "mini_bookmarks_menu_id");
        bindIn(content, "mini_reqdesktop_text_menu_id");
        bindIn(content, "mini_reqdesktop_menu_id");
        bindIn(content, "mini_preferences_menu_id");

        desktopCheckBox = (CheckBox) content.findViewById(res("id", "mini_reqdesktop_menu_id"));
        setMenuTextColor(content, "mini_openathers_menu_id");
        setMenuTextColor(content, "mini_home_menu_id");
        setMenuTextColor(content, "mini_bookmarks_menu_id");
        setMenuTextColor(content, "mini_reqdesktop_text_menu_id");
        setMenuTextColor(content, "mini_preferences_menu_id");
        if (Build.VERSION.SDK_INT >= 21) {
            desktopCheckBox.setButtonTintList(ColorStateList.valueOf(Color.WHITE));
        }
        menu = new PopupWindow(content, Math.min(dp(360), getResources().getDisplayMetrics().widthPixels),
                ViewGroup.LayoutParams.WRAP_CONTENT, true);
        menu.setOutsideTouchable(true);
        menu.setBackgroundDrawable(getResources().getDrawable(android.R.drawable.dialog_holo_light_frame));
        if (Build.VERSION.SDK_INT >= 21) {
            menu.setElevation(dp(8));
        }
    }

    @Override
    public void onClick(View clicked) {
        int id = clicked.getId();
        if (id == res("id", "back")) {
            webView.goBack();
        } else if (id == res("id", "forward")) {
            webView.goForward();
        } else if (id == res("id", "reload")) {
            if (loading) {
                webView.stopLoading();
            } else {
                webView.reload();
            }
        } else if (id == res("id", "star")) {
            addBookmark();
        } else if (id == res("id", "call_browser")
                || id == res("id", "mini_openathers_menu_id")) {
            openExternal(webView.getUrl());
        } else if (id == res("id", "mini_menu")) {
            updateNavigation();
            desktopCheckBox.setChecked(isDesktopMode());
            if (Build.VERSION.SDK_INT >= 19) {
                menu.showAsDropDown(clicked, 0, 0, Gravity.RIGHT);
            } else {
                menu.showAsDropDown(clicked);
            }
            return;
        } else if (id == res("id", "mini_home_menu_id")) {
            loadAddress(DEFAULT_HOME);
        } else if (id == res("id", "mini_bookmarks_menu_id")) {
            showBookmarks();
        } else if (id == res("id", "mini_reqdesktop_text_menu_id")
                || id == res("id", "mini_reqdesktop_menu_id")) {
            setDesktopMode(!isDesktopMode());
        } else if (id == res("id", "mini_preferences_menu_id")) {
            openPreferences();
        }
        if (menu != null) {
            menu.dismiss();
        }
    }

    private void addBookmark() {
        String url = webView.getUrl();
        if (url == null || !(url.startsWith("http://") || url.startsWith("https://"))) {
            Toast.makeText(this, text("bookmark_not_saved", "無法儲存書籤。"), Toast.LENGTH_SHORT).show();
            return;
        }
        Cursor existing = null;
        try {
            existing = getContentResolver().query(BOOKMARKS, new String[] {"_id"},
                    "url=?", new String[] {url}, null);
            if (existing != null && existing.moveToFirst()) {
                Toast.makeText(this, text("added_to_bookmarks", "已加入書籤。"), Toast.LENGTH_SHORT).show();
                return;
            }
            ContentValues values = new ContentValues();
            values.put("title", webView.getTitle() == null ? url : webView.getTitle());
            values.put("url", url);
            values.put("folder", 0);
            values.put("parent", 1);
            Uri result = getContentResolver().insert(BOOKMARKS, values);
            Toast.makeText(this, result == null
                            ? text("bookmark_not_saved", "無法儲存書籤。")
                            : text("added_to_bookmarks", "已加入書籤。"),
                    Toast.LENGTH_SHORT).show();
        } catch (RuntimeException error) {
            Toast.makeText(this, text("bookmark_not_saved", "無法儲存書籤。"), Toast.LENGTH_SHORT).show();
        } finally {
            if (existing != null) {
                existing.close();
            }
        }
    }

    private void showBookmarks() {
        final List<String> urls = new ArrayList<String>();
        final List<String> labels = new ArrayList<String>();
        Cursor cursor = null;
        try {
            cursor = getContentResolver().query(BOOKMARKS,
                    new String[] {"title", "url"}, "folder=0", null, "position ASC, _id ASC");
            while (cursor != null && cursor.moveToNext()) {
                String url = cursor.getString(1);
                if (url != null && url.length() > 0) {
                    urls.add(url);
                    String title = cursor.getString(0);
                    labels.add(title == null || title.length() == 0 ? url : title);
                }
            }
        } catch (RuntimeException ignored) {
            // The original provider may have no initialized root on a fresh install.
        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
        if (urls.isEmpty()) {
            Toast.makeText(this, text("empty_bookmarks_folder", "沒有書籤。"), Toast.LENGTH_SHORT).show();
            return;
        }
        new AlertDialog.Builder(this)
                .setTitle(text("tab_bookmarks", "書籤"))
                .setItems(labels.toArray(new String[labels.size()]),
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                loadAddress(urls.get(which));
                            }
                        })
                .setNegativeButton(android.R.string.cancel, null)
                .show();
    }

    private void setDesktopMode(boolean enabled) {
        WebSettings settings = webView.getSettings();
        if (enabled) {
            settings.setUserAgentString(desktopUserAgent());
            settings.setUseWideViewPort(true);
            settings.setLoadWithOverviewMode(true);
        } else {
            settings.setUserAgentString(mobileUserAgent);
        }
        getPreferences(MODE_PRIVATE).edit().putBoolean("desktop", enabled).apply();
        desktopCheckBox.setChecked(enabled);
        webView.reload();
    }

    private boolean isDesktopMode() {
        return getPreferences(MODE_PRIVATE).getBoolean("desktop", false);
    }

    private String desktopUserAgent() {
        return "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 "
                + "(KHTML, like Gecko) Chrome/120.0 Safari/537.36";
    }

    private void initializeSonyConfiguration() {
        try {
            Class<?> type = Class.forName("com.android.browser.plusone.SonyCustomizedConfig");
            Method initialize = type.getMethod("initialize", android.content.Context.class);
            initialize.invoke(null, this);
        } catch (Exception error) {
            throw new IllegalStateException("Sony browser configuration unavailable", error);
        }
    }

    private void openPreferences() {
        try {
            Intent intent = new Intent();
            intent.setClassName(this, "com.android.browser.BrowserPreferencesPage");
            intent.putExtra("currentPage", webView.getUrl());
            startActivity(intent);
        } catch (RuntimeException error) {
            Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                    Uri.parse("package:" + getPackageName()));
            startActivity(intent);
        }
    }

    private boolean openExternal(String url) {
        if (url == null || url.length() == 0) {
            return false;
        }
        try {
            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
            intent.addCategory(Intent.CATEGORY_BROWSABLE);
            intent.setPackage(null);
            startActivity(Intent.createChooser(intent, text("open_others", "使用其他應用程式開啟")));
            return true;
        } catch (ActivityNotFoundException error) {
            Toast.makeText(this, url, Toast.LENGTH_SHORT).show();
            return false;
        }
    }

    private void loadAddress(String raw) {
        String url = raw == null ? "" : raw.trim();
        if (url.length() == 0) {
            return;
        }
        if (!url.startsWith("http://") && !url.startsWith("https://")
                && !url.startsWith("file://") && !url.startsWith("content://")) {
            url = url.indexOf('.') >= 0 && url.indexOf(' ') < 0
                    ? "https://" + url
                    : "https://www.google.com/search?q=" + Uri.encode(url);
        }
        addressBar.setText(url);
        webView.loadUrl(url);
        webView.requestFocus();
        InputMethodManager keyboard = (InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
        if (keyboard != null) {
            keyboard.hideSoftInputFromWindow(addressBar.getWindowToken(), 0);
        }
    }

    private void updateNavigation() {
        setEnabled(backButton, webView.canGoBack());
        setEnabled(forwardButton, webView.canGoForward());
        if (menu != null && menu.getContentView() != null) {
            setEnabled(menu.getContentView().findViewById(res("id", "forward")), webView.canGoForward());
        }
    }

    private void setEnabled(View target, boolean enabled) {
        if (target != null) {
            target.setEnabled(enabled);
            target.setAlpha(enabled ? 1.0f : 0.35f);
        }
    }

    private void applyResponsiveToolbar() {
        boolean narrow = getResources().getDisplayMetrics().widthPixels
                / getResources().getDisplayMetrics().density < 600.0f;
        View star = view("star");
        View external = view("call_browser");
        if (star != null) {
            star.setVisibility(narrow ? View.GONE : View.VISIBLE);
        }
        if (external != null) {
            external.setVisibility(narrow ? View.GONE : View.VISIBLE);
        }
    }

    private void setMenuTextColor(View root, String name) {
        View target = root.findViewById(res("id", name));
        if (target instanceof TextView) {
            ((TextView) target).setTextColor(Color.WHITE);
        }
    }

    private void bind(String name) {
        View target = view(name);
        if (target != null) {
            target.setOnClickListener(this);
        }
    }

    private void bindIn(View root, String name) {
        View target = root.findViewById(res("id", name));
        if (target != null) {
            target.setOnClickListener(this);
        }
    }

    private void hide(String name) {
        View target = view(name);
        if (target != null) {
            target.setVisibility(View.GONE);
        }
    }

    private void hideIn(View root, String name) {
        View target = root.findViewById(res("id", name));
        if (target != null) {
            target.setVisibility(View.GONE);
        }
    }

    private View view(String name) {
        return findViewById(res("id", name));
    }

    private int res(String type, String name) {
        return getResources().getIdentifier(name, type, getPackageName());
    }

    private String text(String name, String fallback) {
        int id = res("string", name);
        return id == 0 ? fallback : getString(id);
    }

    private int dp(int value) {
        return (int) (value * getResources().getDisplayMetrics().density + 0.5f);
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putString("url", webView == null ? null : webView.getUrl());
    }

    @Override
    public void onConfigurationChanged(Configuration configuration) {
        super.onConfigurationChanged(configuration);
        applyResponsiveToolbar();
        if (menu != null && menu.isShowing()) {
            menu.dismiss();
        }
    }

    @Override
    public void onBackPressed() {
        if (webView != null && webView.canGoBack()) {
            webView.goBack();
        } else {
            super.onBackPressed();
        }
    }

    @Override
    protected void onDestroy() {
        if (menu != null) {
            menu.dismiss();
        }
        if (webView != null) {
            webView.destroy();
        }
        super.onDestroy();
    }
}

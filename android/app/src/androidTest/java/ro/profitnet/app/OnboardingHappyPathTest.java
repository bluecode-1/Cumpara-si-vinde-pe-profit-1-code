package ro.profitnet.app;

import static androidx.test.espresso.Espresso.closeSoftKeyboard;
import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.action.ViewActions.click;
import static androidx.test.espresso.action.ViewActions.replaceText;
import static androidx.test.espresso.action.ViewActions.scrollTo;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.matcher.RootMatchers.isDialog;
import static androidx.test.espresso.matcher.ViewMatchers.isChecked;
import static androidx.test.espresso.matcher.ViewMatchers.isDisplayed;
import static androidx.test.espresso.matcher.ViewMatchers.isEnabled;
import static androidx.test.espresso.matcher.ViewMatchers.isNotChecked;
import static androidx.test.espresso.matcher.ViewMatchers.withId;
import static androidx.test.espresso.matcher.ViewMatchers.withText;

import static org.hamcrest.Matchers.not;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import android.content.Context;

import androidx.test.core.app.ActivityScenario;
import androidx.test.core.app.ApplicationProvider;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.filters.LargeTest;

import javax.inject.Inject;

import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import dagger.hilt.android.testing.HiltAndroidRule;
import dagger.hilt.android.testing.HiltAndroidTest;
import ro.profitnet.app.core.database.ProfitNetDatabase;
import ro.profitnet.app.core.database.onboarding.OnboardingProgressEntity;
import ro.profitnet.app.core.security.SessionManager;

/**
 * Onboarding happy path against the debug fake API (demo mode): Welcome → Phone → Code →
 * Consents → Name → Location (manual city) → Interests → Home, then sign out.
 *
 * <p>Runs on a device or emulator: {@code ./gradlew :app:connectedDebugAndroidTest}.
 */
@LargeTest
@HiltAndroidTest
@RunWith(AndroidJUnit4.class)
public class OnboardingHappyPathTest {

    private static final String DISPLAY_NAME = "Ioana";

    @Rule
    public HiltAndroidRule hiltRule = new HiltAndroidRule(this);

    @Inject
    SessionManager sessionManager;

    @Inject
    ProfitNetDatabase database;

    private Context context;
    private ActivityScenario<MainActivity> scenario;

    @Before
    public void setUp() {
        hiltRule.inject();
        context = ApplicationProvider.getApplicationContext();
        // Start signed out, with no saved progress.
        sessionManager.clear();
        database.clearAllTables();
        scenario = ActivityScenario.launch(MainActivity.class);
    }

    @After
    public void tearDown() {
        if (scenario != null) {
            scenario.close();
        }
        sessionManager.clear();
        database.clearAllTables();
    }

    @Test
    public void newUserCompletesOnboardingAndReachesHome() {
        // 1. Welcome
        onView(withText(ro.profitnet.app.feature.onboarding.R.string.welcome_title))
                .check(matches(isDisplayed()));
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.startButton))
                .perform(scrollTo(), click());

        // 2. Phone: national form with spaces is accepted and normalized
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.phoneInput))
                .perform(replaceText("0712 345 678"));
        closeSoftKeyboard();
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.submitButton))
                .perform(scrollTo(), click());

        // 3. Code: submitted automatically at the sixth digit
        onView(withText(context.getString(
                ro.profitnet.app.feature.onboarding.R.string.code_subtitle, "+40 712 345 678")))
                .check(matches(isDisplayed()));
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.codeInput))
                .perform(replaceText("123456"));

        // 4. Consents: nothing pre-ticked, Continue needs both required consents
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.termsCheck))
                .check(matches(isNotChecked()));
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.marketingCheck))
                .check(matches(isNotChecked()));
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.analyticsCheck))
                .check(matches(isNotChecked()));
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.aiCheck))
                .check(matches(isNotChecked()));
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.continueButton))
                .check(matches(not(isEnabled())));
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.termsCheck))
                .perform(scrollTo(), click());
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.continueButton))
                .check(matches(not(isEnabled())));
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.privacyCheck))
                .perform(scrollTo(), click())
                .check(matches(isChecked()));
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.continueButton))
                .perform(scrollTo(), click());

        // 5. Name
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.nameInput))
                .perform(replaceText(DISPLAY_NAME));
        closeSoftKeyboard();
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.continueButton))
                .perform(scrollTo(), click());

        // 6. Location: pick the city manually (no permission dialog involved)
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.pickCityButton))
                .perform(scrollTo(), click());
        onView(withText("Cluj-Napoca")).inRoot(isDialog()).perform(click());

        // 7. Interests: categories come from api/fixtures/categories.200.json
        onView(withText("Cărți")).perform(scrollTo(), click());
        onView(withId(ro.profitnet.app.feature.onboarding.R.id.finishButton))
                .perform(scrollTo(), click());

        // Home
        onView(withText(context.getString(
                ro.profitnet.app.feature.home.R.string.home_greeting, DISPLAY_NAME)))
                .check(matches(isDisplayed()));
        assertTrue(sessionManager.hasSession());
        OnboardingProgressEntity progress = database.onboardingProgressDao().get();
        assertEquals("COMPLETED", progress.step);
        assertEquals("+40712345678", progress.phone);

        // Sign out returns to Welcome and removes the local session
        onView(withId(ro.profitnet.app.feature.home.R.id.logoutButton))
                .perform(scrollTo(), click());
        onView(withText(ro.profitnet.app.feature.onboarding.R.string.welcome_title))
                .check(matches(isDisplayed()));
        assertTrue(!sessionManager.hasSession());
    }
}

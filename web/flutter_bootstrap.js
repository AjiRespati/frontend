{{flutter_js}}
{{flutter_build_config}}

//TODO: APP VERSION
const appVersion = "1.1.6";

console.log("Version: ", appVersion);

const progressBar = document.getElementById('progressBar');
const percentage = document.getElementById('percentage');
const loadText = document.getElementById('loadingText');
let loadingProgress = 0;
let initialLoadingInterval;

const date = new Date(Date.now());
const now = date.toISOString();
localStorage.setItem("flutter.lastLogin", JSON.stringify(now));

function updateProgress(progress) {
  loadingProgress = progress;
  progressBar.style.backgroundSize = `${progress}%`;
  percentage.textContent = `${Math.round(progress)}%`;

  if (progress >= 100) {
    setTimeout(() => {
      document.body.classList.remove('bodyload');
      progressBar.style.display = 'none';
      percentage.style.display = 'none';
    }, 500);
  }
}
 
loadText.textContent = "Loading application..."; 

function startInitialLoading() {
  let currentProgress = 0;
  const targetProgress = 49;
  const duration = 20000;
  const steps = 100; 
  const interval = duration / steps;
  const progressPerStep = targetProgress / steps;

  return setInterval(() => {
    if (currentProgress < targetProgress) {
      currentProgress += progressPerStep;
      updateProgress(Math.min(currentProgress, targetProgress));
    }
  }, interval);
}

initialLoadingInterval = startInitialLoading();

function initializeProgressTracking() {
  let progressSteps = {
    initEngine: 50,
    loadEntrypoint: 75,
    runApp: 100,
  };

  _flutter.loader.load({
    onEntrypointLoaded: async function (engineInitializer) {
      if (initialLoadingInterval) {
        clearInterval(initialLoadingInterval);
      }

      updateProgress(progressSteps.loadEntrypoint);

      const appRunner = await engineInitializer.initializeEngine();
      updateProgress(progressSteps.initEngine);

      updateProgress(progressSteps.runApp);
      await appRunner.runApp();
    }
  });
}

window.addEventListener('load', function () {
  updateProgress(0); // Initial progress
  initializeProgressTracking();
});
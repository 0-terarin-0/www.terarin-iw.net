// Moves between pages without reloading them. A link click fetches the static HTML of the next page and swaps only its
// <main>, so the header stays hydrated. Every page still works as plain HTML, so anything unusual below just falls back
// to a normal page load.
(() => {
  const pages = new Map();
  let currentPath = location.pathname;
  let latestNavigation = 0;

  const isInternalPage = (url) => url.origin === location.origin && !/\.[^/]+$/.test(url.pathname);
  const pagePath = (url) => (url.pathname.endsWith('/') ? url.pathname : `${url.pathname}/`);

  const load = (path) => {
    if (pages.has(path)) return pages.get(path);
    const page = fetch(path).then(async (response) => {
      if (!response.ok) throw new Error(`${response.status} ${path}`);
      return new DOMParser().parseFromString(await response.text(), 'text/html');
    });
    pages.set(path, page);
    page.catch(() => pages.delete(path));
    return page;
  };

  const prefetch = (path) => load(path).catch(() => {});

  const swap = (next) => {
    const main = document.querySelector('main');
    const nextMain = next.querySelector('main');
    main.replaceWith(document.adoptNode(nextMain.cloneNode(true)));

    document.title = next.title;
    const description = next.querySelector('meta[name="description"]')?.content ?? '';
    document.querySelector('meta[name="description"]')?.setAttribute('content', description);

    const links = document.querySelectorAll('header nav a');
    next.querySelectorAll('header nav a').forEach((link, index) => {
      const current = link.getAttribute('aria-current');
      if (current) links[index].setAttribute('aria-current', current);
      else links[index].removeAttribute('aria-current');
    });
  };

  const animate = (update) => {
    const reducedMotion = matchMedia('(prefers-reduced-motion: reduce)').matches;
    // A skipped transition rejects `ready`, but `update` still runs.
    if (document.startViewTransition && !reducedMotion) document.startViewTransition(update).ready.catch(() => {});
    else update();
  };

  const moveFocus = () => {
    const main = document.querySelector('main');
    main.tabIndex = -1;
    main.focus({preventScroll: true});
  };

  const navigate = async (url, {push, scrollY = 0}) => {
    const navigation = ++latestNavigation;
    const path = pagePath(url);

    let next;
    try {
      next = await load(path);
    } catch {
      location.href = url.href;
      return;
    }
    if (navigation !== latestNavigation) return;

    // Components hydrated by Jaspr in <main> only start on a full page load.
    if (next.querySelector('main').innerHTML.includes('<!--@')) {
      location.href = url.href;
      return;
    }

    animate(() => {
      if (push) history.pushState({scrollY: 0}, '', path + url.search + url.hash);
      currentPath = location.pathname;
      swap(next);

      const target = url.hash && document.getElementById(decodeURIComponent(url.hash.slice(1)));
      if (target) target.scrollIntoView();
      else scrollTo(0, scrollY);
      moveFocus();
    });
  };

  document.addEventListener('click', (event) => {
    const link = event.target.closest?.('a[href]');
    if (!link || event.defaultPrevented || event.button !== 0) return;
    if (event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
    if (link.target || link.hasAttribute('download')) return;

    const url = new URL(link.href);
    if (!isInternalPage(url)) return;
    if (pagePath(url) === pagePath(location) && url.hash) return;

    event.preventDefault();
    if (pagePath(url) === pagePath(location)) scrollTo(0, 0);
    else navigate(url, {push: true});
  });

  addEventListener('popstate', (event) => {
    if (pagePath(location) === pagePath({pathname: currentPath})) return;
    navigate(new URL(location.href), {push: false, scrollY: event.state?.scrollY ?? 0});
  });

  // The position lives in the history entry, so it also survives a reload.
  history.scrollRestoration = 'manual';
  if (history.state?.scrollY) scrollTo(0, history.state.scrollY);

  let scrollTimer;
  addEventListener('scroll', () => {
    clearTimeout(scrollTimer);
    scrollTimer = setTimeout(() => history.replaceState({scrollY}, ''), 100);
  }, {passive: true});

  const prefetchLink = (event) => {
    const link = event.target.closest?.('a[href]');
    if (!link) return;
    const url = new URL(link.href);
    if (isInternalPage(url)) prefetch(pagePath(url));
  };
  document.addEventListener('pointerover', prefetchLink, {passive: true});
  document.addEventListener('touchstart', prefetchLink, {passive: true});

  // The pages in the header are small, and having them ready also helps on touch screens and in every browser.
  if (!navigator.connection?.saveData) {
    (window.requestIdleCallback ?? setTimeout)(() => {
      document.querySelectorAll('header nav a').forEach((link) => prefetch(pagePath(new URL(link.href))));
    });
  }
})();
